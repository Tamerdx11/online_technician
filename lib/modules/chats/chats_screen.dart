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
            title:Row(
              children: const [
                Spacer(),
                Center(child: Text('المحادثات')),
                SizedBox(width: 10.0,),
              ],
            ),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('person')
                .doc(uId.toString())
                .snapshots(),
            builder:(context, snapshot){
              if (snapshot.hasError) {
                return const Center(child: Text('error 404'));
              }
              if(snapshot.hasData){
                Map map = snapshot.data!.data()?['chatList'];
                Map chatData = Map.fromEntries(
                    map.entries.toList()..sort((e1, e2) => e1.value[1].compareTo(e2.value[1]))
                );

                return ListView.separated(
                  physics:const  BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildChatItem(chatData.keys.toList()[index],chatData,context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: chatData.length,
                );
              }
              return const Center(child: CircularProgressIndicator());
            } ,
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
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                chatData[id][2].toString(),
              ),
            ),
            const SizedBox(
              width: 13.0,
            ),
            Text(
              chatData[id][3],
              style: const TextStyle(
                overflow: TextOverflow.clip,
                height: 1.4,
                fontWeight: FontWeight.w500,
                fontSize: 16.0
              ),
            ),
            const Spacer(),
            Text(
              chatData[id][0],
              style: const TextStyle(
                overflow: TextOverflow.clip,
                height: 1.4,
                fontSize: 15.0,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 20.0,),
          ],
        ),
      ),
    ),
  );
}





