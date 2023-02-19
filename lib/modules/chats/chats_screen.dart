// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    messagesNumber = 0;
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: HexColor('#0A81AB'),
              elevation: 3.0,
              title:const Text("المحادثات",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoNaskhArabic',
                      fontWeight: FontWeight.w600)),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.white,
                ),
              ),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('person')
                .doc(uId.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('error 404'));
              }
              if (snapshot.hasData) {
                Map map = snapshot.data!.data()?['chatList'];
                Map chatData = Map.fromEntries(map.entries.toList()
                  ..sort((e1, e2) => e2.value[1].compareTo(e1.value[1])));

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildChatItem(
                        chatData.keys.toList()[index], chatData, context),
                    separatorBuilder: (context, index) => Container(),
                    itemCount: chatData.length,
                  ),
                );
              }
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            },
          ),
        );
      },
    );
  }

  Widget buildChatItem(String id, Map chatData, context) => Material(
    color: Colors.white,
        child: InkWell(
          onTap: () {
            AppCubit.get(context).goToChatDetails(id, context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(00),
                  borderSide:const BorderSide(
                    color: Colors.white,
                    width: 0,
                  ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Icon(Icons.arrow_back_ios, color: Colors.grey,),
                        ),
                        const SizedBox(width: 20.0,),
                        Flexible(
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                                chatData[id][0],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(

                                  height: 1.4,
                                  fontSize: 13.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600
                                ),
                                softWrap: true,
                                maxLines: 1,
                                textDirection: TextDirection.rtl,
                              ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          chatData[id][3],
                          style: const TextStyle(
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                          ),
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CircleAvatar(
                            radius: 30.2,
                            backgroundColor: Colors.black87,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                chatData[id][2].toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(width: double.infinity,height: 1, color: Colors.grey,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
