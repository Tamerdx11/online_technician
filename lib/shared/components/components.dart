import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:pinput/pinput.dart';

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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: color),
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
  int maxLines = 1,
}) =>
    TextFormField(
      validator: validate,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      onTap: onTap,
      maxLines: maxLines,
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
      // MaterialPageRoute(
      //   builder: (context) => widget,
      // ),
      PageRouteBuilder(
        transitionDuration:const Duration(milliseconds: 1500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
            return ScaleTransition(scale: animation, child: child, alignment: Alignment.center,);
          },
          pageBuilder: (context, animation, secondaryAnimation){
            return widget;
          },
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
  double? elevation = 0,
  Color? arrowColor = Colors.black,
}) =>
    AppBar(
      backgroundColor: color,
      elevation: elevation,
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
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: arrowColor,
            size: 30.0,
          ),
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
        fontSize: 15.0);

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

///----------------------------------- build one search item and  items builder------

Widget buildSearchResultItem(data, context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Card(
        elevation: 3.0,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:const BorderSide(
              color: Colors.black,
              width: 0.05,
            ),
        ),
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
                AppCubit.get(context).goToChatDetails(
                  data['uId'].toString(),
                  context,
                );
              },
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      AppCubit.get(context).getDistance(
                        lat1: AppCubit.get(context).model.latitude,
                        long1: AppCubit.get(context).model.longitude,
                        lat2: data['latitude'],
                        long2: data['longitude'],
                      ).toInt()==0?'يبعد عنك مسافة ${(AppCubit.get(context).getDistance(
                          lat1: AppCubit.get(context).model.latitude,
                          long1: AppCubit.get(context).model.longitude,
                          lat2: data['latitude'],
                          long2: data['longitude'],
                      )*1000).toInt()} م':'يبعد عنك مسافة ${AppCubit.get(context).getDistance(
                        lat1: AppCubit.get(context).model.latitude,
                        long1: AppCubit.get(context).model.longitude,
                        lat2: data['latitude'],
                        long2: data['longitude'],
                      ).toInt()} كم',
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.4,
                        fontSize: 11.0
                      ),
                    ),
                    const SizedBox(width: 10.0,),
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
                  ],
                ),
                const SizedBox(
                  height: 7.0,
                ),
                Row(
                  children: [
                    Text(
                      data['location'].toString(),
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const Icon(Icons.location_on_outlined, size: 18.0, color: Colors.blueAccent,),
                    const SizedBox(width: 8.0,),
                    Text(
                       data['profession'].toString(),
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2.0,),
                    const Icon(Icons.handyman_sharp, size: 18.0, color: Colors.green,),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: InkWell(
                child: CircleAvatar(
                  radius: 30.2,
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

Widget searchResultsBuilder(data, context) => ListView.separated(
  physics: const BouncingScrollPhysics(),
  itemBuilder: (context, index) {
    return buildSearchResultItem(data[index], context);
  },
  separatorBuilder: (context, index) => const SizedBox(
    height: 0.0,
  ),
  itemCount: data.length,
);

///---------------------------------- E2-----------------------------------------

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

final defaultPinTheme = PinTheme(
  width: 40,
  height: 40,
  textStyle: const TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    color: Colors.black87,
  ),
);

