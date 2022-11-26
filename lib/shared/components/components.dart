import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_technician/models/post.dart';
import 'package:online_technician/shared/cubit/cubit.dart';

///---------- customized button ----------

Widget defaultButton({
  Color color = Colors.teal,
  Color? textColor,
  double width = double.infinity,
  bool isUpperCase = true,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      color: color,
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
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
  IconButton? suffixIcon,
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
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
      onFieldSubmitted: onSubmitted,
      onChanged: onchange,
    );

///---------- navigation ----------

Future navigateTo(context, widget)=> Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

Future navigateToAndFinish(context, widget)=> Navigator.pushAndRemoveUntil(
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
})=>AppBar(
  backgroundColor: color,
  title: Text(title,style: TextStyle(color: textColor),),
  actions: actions,
  titleSpacing: 10.0,
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon:const Icon(Icons.keyboard_double_arrow_left_rounded),
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

enum ToastState { SUCCESS, ERROR, WORNING }

Color chooseToastColor(ToastState state) {
  switch (state) {
    case ToastState.SUCCESS:
      return Colors.green;
    case ToastState.ERROR:
      return Colors.red;
    case ToastState.WORNING:
      return Colors.yellow;
  }
}

///---------------- build post item --------------

Widget buildPostItem(PostModel model, context, index) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10.0),
  child: SizedBox(
    width: double.infinity,
    child: Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(model.userImage.toString()),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              model.name.toString(),
                              style:const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 14.0,
                            ),
                          ],
                        ),
                        Text(
                          model.dateTime.toString(),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                              height: 1.4),
                        ),
                      ],
                    )),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 15.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: double.infinity,
                color: Colors.grey,
                height: 1.0,
              ),
            ),
            Text(
              model.postText.toString(),
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            if (model.postImages.toString().isNotEmpty)///there may be more than an image ------------
              Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: NetworkImage(model.postImages.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),///for one image
            const SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: () {
                AppCubit.get(context).likePost(
                    AppCubit.get(context).postId[index]);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 18.0,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '${AppCubit.get(context).likes[index]}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);


///----------------------------------- build one search item --- items builder------/// need to be customize ***********

Widget buildSearchResultItem(data, context) =>InkWell(
  onTap: () {},
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(

      children: [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.0),

            image: DecorationImage(

              image: NetworkImage(data['urlToImage'].toString()),

              fit: BoxFit.cover,

            ),

          ),

        ),

        const SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: SizedBox(

            height: 120.0,

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Expanded(

                  child: Text(

                    data['title'].toString(),

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,

                    style: Theme.of(context).textTheme.bodyText1,

                  ),

                ),

                Text(

                  data['publishedAt'].toString(),

                  style: const TextStyle(

                    color: Colors.grey,

                  ),

                ),

              ],

            ),

          ),

        ),

      ],

    ),
  ),
);

Widget searchResultsBuilder(data, context)=> ConditionalBuilder(
  condition: data.isNotEmpty,
  builder: (context) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    itemBuilder: (context, index) => buildSearchResultItem(data[index], context),
    separatorBuilder: (context, index) =>  Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.black12,
    ),
    itemCount: data.length,
  ),
  fallback: (context) => const Center(child: CircularProgressIndicator()),
);
