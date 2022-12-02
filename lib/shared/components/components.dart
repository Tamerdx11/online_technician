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
  title: Text(title,style: TextStyle(color: textColor,fontSize: 17.0),),
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

Widget buildPostItem(PostModel model,context,index)=>Card(
  clipBehavior: Clip.antiAliasWithSaveLayer,
  elevation: 5,
  margin: const EdgeInsets.symmetric(horizontal: 8),
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        Row(
          children:
          [
            CircleAvatar(
              radius: 20,
              backgroundImage:  NetworkImage(
                '${model.userImage}',
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
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
                        color:Colors.black,
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
              onPressed: (){},
              icon:const Icon(
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
        if(model.postImages!='')
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
          children:
          [
            Expanded(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Row(
                    children:
                    [
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      AppCubit.get(context).isLove?Text(
                        '${AppCubit.get(context).likes[index]}',
                        style: Theme.of(context).textTheme.caption,
                      ):Text('${AppCubit.get(context).likes[index]}'),
                    ],
                  ),
                ),
                onTap: (){},
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
            children:
            [
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
          onTap: ()
          {
            AppCubit.get(context).isLove?AppCubit.get(context).likePost(AppCubit.get(context).postId[index]):AppCubit.get(context).unlikePost(AppCubit.get(context).postId[index]);
            AppCubit.get(context).showLove();
          },
        ),
      ],
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


///****************** E2

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);