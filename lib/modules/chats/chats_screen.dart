// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text("المحادثات",
                  style: TextStyle(
                      color: Colors.black,
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
                  ..sort((e1, e2) => e1.value[1].compareTo(e2.value[1])));

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildChatItem(
                      chatData.keys.toList()[index], chatData, context),
                  separatorBuilder: (context, index) => Container(),
                  itemCount: chatData.length,
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
        child: InkWell(
          onTap: () {
            AppCubit.get(context).goToChatDetails(id, context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: .3,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      chatData[id][0],
                      style: const TextStyle(
                        height: 1.4,
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    chatData[id][3],
                    style: const TextStyle(
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                      chatData[id][2].toString(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
