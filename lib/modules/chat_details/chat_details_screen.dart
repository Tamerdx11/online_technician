import 'dart:async';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/models/message.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

// ignore: must_be_immutable
class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;

  ChatDetailsScreen({
    super.key,
    required this.userModel,
  });

  var messageController = TextEditingController();
  ScrollController listViewScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    Timer(const Duration(seconds: 1),() {
      if(listViewScrollController.hasClients){
        listViewScrollController.animateTo(
          listViewScrollController.position.maxScrollExtent,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    },
    );

    return Builder(
      builder: (BuildContext context) {
        AppCubit.get(context).getMessages(
          receiverId: userModel.uId,
        );

        return BlocConsumer<AppCubit, AppState>(
          listener: (context, state) {},
          builder: (context, state) {

            return Scaffold(
              backgroundColor: HexColor('#ebebeb'),
              appBar: AppBar(
                backgroundColor: HexColor('#78b7b7'),
                elevation: 3.0,
                centerTitle: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  ),
                ),
                titleSpacing: 0.0,
                title: InkWell(
                  onTap: () {
                    navigateTo(context, ProfileScreen(
                      id: userModel.uId,
                      name: userModel.name,
                    ));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 21.1,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 21.0,
                          backgroundImage: NetworkImage(
                            '${userModel.userImage}',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        userModel.name.toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: listViewScrollController,
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
                      const SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#c6dfe7'),
                                border: Border.all(
                                  color: Colors.black87,
                                  width: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(
                                  30.0,
                                ),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: TextFormField(
                                  textDirection: TextDirection.rtl,
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'الرسالة..',
                                      hintStyle: TextStyle(
                                        color: Colors.grey
                                      ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15.0,),
                          Container(
                            decoration: BoxDecoration(
                              color: HexColor('#78b7b7'),
                              border: Border.all(
                                color: Colors.black87,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(
                                30.0,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                AppCubit.get(context).sendMessage(
                                  name: userModel.name,
                                  image: userModel.userImage,
                                  chatList: userModel.chatList,
                                  receiverId: userModel.uId.toString(),
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                  token: userModel.token.toString(),
                                );
                                messageController.clear();
                              },
                              icon:const Icon(
                                Icons.send_sharp,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: HexColor('#78b7b7'),
            borderRadius:const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            '${model.text}',
            style:const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration:const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            '${model.text}',
            style: TextStyle(
                color: HexColor('#78b7b7'),
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      );

}
