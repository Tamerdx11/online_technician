// ignore: import_of_legacy_library_into_null_safe
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import '../chat_details/chat_details_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {

        return Scaffold(
          body: ConditionalBuilder(
            condition: true,//AppCubit.get(context).users.isNotEmpty,
            builder: (context) => const Center(child: Text('chats')),
            //     ListView.separated(
            //   physics: const BouncingScrollPhysics(),
            //   itemBuilder: (context, index) => buildChatItem(context, AppCubit.get(context).users[index]),
            //   separatorBuilder: (context, index) => Padding(
            //     padding: const EdgeInsets.only(
            //       left: 20.0,
            //     ),
            //     child: Container(
            //       width: double.infinity,
            //       color: Colors.grey,
            //       height: 1.0,
            //     ),
            //   ),
            //   itemCount: AppCubit.get(context).users.length,
            // ),
            fallback: (context) =>  const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  ///---------- build chat items ----------

  Widget buildChatItem(BuildContext context ,UserModel model)=> InkWell(
    onTap: () {
      navigateTo(context, ChatDetailsScreen( userModel: model,));
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(model.userImage.toString()),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
            model.name.toString(),
            style:const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              height: 2.0,
            ),
          ),
        ],
      ),
    ),
  );

}
