import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/models/message.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

// ignore: must_be_immutable
class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;
  var messageController = TextEditingController();

  ChatDetailsScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).getMessages(receiverId: userModel.uId!);

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox(
              width: 8.0,
            ),
            leadingWidth: 0.0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(userModel.userImage.toString()),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Text(
                  userModel.name.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                splashRadius: 22.0,
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
            elevation: 5.0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var message = AppCubit.get(context).messages[index];
                      if (AppCubit.get(context).model!.uId ==
                          message.senderId) {
                        return buildMyMessage(message);
                      }
                      return buildMessage(message);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 15.0,
                    ),
                    itemCount: AppCubit.get(context).messages.length,
                  ),
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "message",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                        child: MaterialButton(
                          minWidth: 1.0,
                          splashColor: Colors.amberAccent,
                          onPressed: () {},
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.grey,
                            size: 25.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                        child: MaterialButton(
                          minWidth: 1.2,
                          color: Colors.blueAccent,
                          splashColor: Colors.amberAccent,
                          onPressed: () {
                            if(messageController.text.isNotEmpty){
                              AppCubit.get(context).sendMessage(
                                receiverId: userModel.uId.toString(),
                                dateTime: DateTime.now().toString(),
                                text: messageController.text,
                              );
                              messageController.text ='';
                            }
                          },
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  ///---------- build received message----------

  Widget buildMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              bottomEnd: Radius.circular(10.0),
            ),
          ),
          child: Text(message.text.toString()),
        ),
      );

  ///---------- build my message----------

  Widget buildMyMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              bottomStart: Radius.circular(10.0),
            ),
          ),
          child: Text(message.text.toString()),
        ),
      );

}
