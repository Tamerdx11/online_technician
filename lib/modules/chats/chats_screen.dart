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
          backgroundColor: HexColor('#ebebeb'),
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: HexColor('#78b7b7'),
              elevation: 5.0,
              title:const Text("المحادثات",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'NotoNaskhArabic',
                      fontWeight: FontWeight.w600)),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.black,
                ),
              )),
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildChatItem(
                        chatData.keys.toList()[index], chatData, context),
                    separatorBuilder: (context, index) => const SizedBox(height: 4.0,),
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
    color: HexColor('#ebebeb'),
        child: InkWell(
          onTap: () {
            AppCubit.get(context).goToChatDetails(id, context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Card(
              elevation: 5.0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:const BorderSide(
                    color: Colors.black,
                    width: .1,
                  ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 20.0,),
                  Text(
                    chatData[id][0],
                    style: const TextStyle(
                      height: 1.4,
                      fontSize: 13.0,
                      color: Colors.black45,
                      fontWeight: FontWeight.w600
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textDirection: TextDirection.rtl,
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
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30.6,
                      backgroundColor: Colors.white,
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
            ),
          ),
        ),
      );
}
