// ignore: import_of_legacy_library_into_null_safe
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import '../chat_details/chat_details_screen.dart';
///E2

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:Center(child: Text('Chats')),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(Icons.search_sharp,),)
            ],
          ),
          body: ConditionalBuilder(
            condition: AppCubit.get(context).users.isNotEmpty,
            builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildChatItem(AppCubit.get(context).users[index], context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: AppCubit.get(context).users.length,

            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),

        );
      },
    );
  }

  Widget buildChatItem(UserModel model, context) => Material(
    child: InkWell(
      onTap: () {
        navigateTo(
          context,
          ChatDetailsScreen(
            userModel: model,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                '${model.userImage}',
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              '${model.name}',
              style: TextStyle(
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ),);
}