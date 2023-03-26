import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/google_map2/GoogleMaps2.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/modules/received_requests/received_requests_screen.dart';
import 'package:online_technician/modules/sent_requests/sent_requests_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('person')
              .doc(uId.toString())
              .snapshots(),
          builder:(context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('error 404'));
            }
            if(snapshot.hasData){
              Map map = snapshot.data!.data()?['notificationList'];

              if(snapshot.data!.data()?['notificationList'].length == 0) {
                return const Center(child: Text("لا يوجد اشعارات"));
              }

              return ListView.separated(
                reverse: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {

                  return InkWell(
                    onTap: () {
                      if(map[map.keys.toList()[index]]['isClickable'] == true)
                        {
                          if(map[map.keys.toList()[index]]['navigateTo'] == 'SentRequestsScreen') {
                            AppCubit.get(context).changeButtonNav(2);
                          }
                          else if(map[map.keys.toList()[index]]['navigateTo'] == 'ReceivedRequestsScreen') {
                            AppCubit.get(context).changeButtonNav(3);
                          }
                        }
                    },
                    child: Card(
                      elevation: 3.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      map[map.keys.toList()[index]]['text'].toString(),
                                      maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,

                                    ),
                                  ),
                                  const Icon(Icons.info, color: Colors.black54,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>const SizedBox(height: 5.0,),
                itemCount: snapshot.data!.data()?['notificationList'].length,
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          },

        );
      },
    );
  }

}
