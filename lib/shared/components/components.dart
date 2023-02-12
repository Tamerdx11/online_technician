import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/models/post.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';

///---------- customized button ----------

Widget defaultButton({
  Color color = Colors.black,
  double width = double.infinity,
  double size = 14,
  bool isUpperCase = true,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), color: color),
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            fontSize: size,
            color: Colors.white,
          ),
        ),
      ),
    );

///---------- reusable text form field ----------

Widget defaultFormText({
  required FormFieldValidator validate,
  required TextEditingController controller,
  required String label,
  ValueChanged? onSubmitted,
  ValueChanged? onchange,
  TextInputType? keyboardType,
  VoidCallback? onTap,
  Icon? prefixIcon,
  Icon? suffixIcon,
  bool isClickable = true,
  bool isPassword = false,
}) =>
    TextFormField(
      validator: validate,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      onTap: onTap,
      enabled: isClickable,
      decoration: InputDecoration(
        prefixIconColor: Colors.black,
        suffixIconColor: Colors.black,
        focusColor: Colors.grey,
        labelText: label,
        floatingLabelStyle:const TextStyle(color: Colors.black54),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintTextDirection: TextDirection.rtl,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
            borderSide:const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:const BorderSide(color: Colors.grey)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
            borderSide:const BorderSide(color: Colors.grey)),
      ),
      onFieldSubmitted: onSubmitted,
      onChanged: onchange,
      cursorColor: Colors.black,
      cursorHeight: 20,
      textDirection: TextDirection.rtl,
    );

///---------- navigation ----------

Future navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Future navigateToAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

///---------- defaultAppBar ----------

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String title = '',
  List<Widget>? actions,
  Color? color,
  Color? textColor,
}) =>
    AppBar(
      backgroundColor: color,
      elevation: 0,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
              color: textColor,
              fontFamily: 'NotoNaskhArabic',
              fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: actions,
      titleSpacing: 10.0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.black,
        ),
      ),
    );

///---------- toast ----------

void showToast({
  required String text,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 10.0);

enum ToastState { SUCCESS, ERROR, WORNING, WELCOME }

Color chooseToastColor(ToastState state) {
  switch (state) {
    case ToastState.SUCCESS:
      return Colors.green;
    case ToastState.ERROR:
      return HexColor('#DC3535');
    case ToastState.WORNING:
      return Colors.green;
    case ToastState.WELCOME:
      return Colors.tealAccent;
  }
}

///---------------- build post item --------------

Widget buildPostItem(PostModel model, context, index) => Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    '${model.userImage}',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.black,
                            size: 18,
                          ),
                        ],
                      ),
                      Text(
                        '${model.dateTime}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Text(
              '${model.postText}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            if (model.postImages != '')
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 15,
                ),
                child: Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${model.postImages}',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          // AppCubit.get(context).isLove?Text(
                          //   '${AppCubit.get(context).likes[index]}',
                          //   style: Theme.of(context).textTheme.caption,
                          // ):Text('${AppCubit.get(context).likes[index]}'),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Love',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              onTap: () {
                // AppCubit.get(context).isLove?AppCubit.get(context).likePost(AppCubit.get(context).postId[index]):AppCubit.get(context).unlikePost(AppCubit.get(context).postId[index]);
                // AppCubit.get(context).showLove();
              },
            ),
          ],
        ),
      ),
    );

///----------------------------------- build one search item --- items builder------

Widget buildSearchResultItem(data, context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Card(
        elevation: 3.0,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:const BorderSide(
              color: Colors.black,
              width: 0.05,
            )),
        child: Row(
          children: [
            const SizedBox(
              width: 15.0,
            ),
            InkWell(
              child: Padding(
                padding:const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.whatsapp,
                  size: 27.0,
                  color: HexColor('#7FB77E'),
                ),
              ),
              onTap: () {
                ///go to chat
                AppCubit.get(context).goToChatDetails(
                  data['uId'].toString(),
                  context,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 27.0,
                    color: Colors.black54,
                  ),
                  Text(
                    data['location'].toString(),
                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                InkWell(
                  child: Text(
                    data['name'].toString(),
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  onTap: (){
                    navigateTo(context, ProfileScreen(
                      id: data['uId'].toString(),
                      name: data['name'].toString(),
                    ));
                  },
                ),
                const SizedBox(
                  height: 7.0,
                ),
                Text(
                  data['profession'].toString(),
                  style: const TextStyle(
                    color: Colors.black54,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 3.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: CircleAvatar(
                  radius: 30.1,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(data['userImage'].toString()),
                  ),
                ),
                onTap: () {
                  navigateTo(context, ProfileScreen(
                    id: data['uId'].toString(),
                    name: data['name'].toString(),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );

Widget searchResultsBuilder(data, context) => ConditionalBuilder(
      condition: data.isNotEmpty,
      builder: (context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) =>
            buildSearchResultItem(data[index], context),
        separatorBuilder: (context, index) => const SizedBox(
          height: 5.0,
        ),
        itemCount: data.length,
      ),
      fallback: (context) => const Center(
          child: CircularProgressIndicator(
        color: Colors.black54,
      )),
    );

///****************** E2

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        end: 30.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );
const BoxDecoration PinOtpDeco = BoxDecoration(
  color: Colors.black,
  shape: BoxShape.circle,
);
const BoxDecoration PinOtpDeco1 = BoxDecoration(
  color: Colors.red,
  shape: BoxShape.circle,
);
