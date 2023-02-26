import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/google_map2/GoogleMaps2.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class SentRequestsScreen extends StatelessWidget {
  const SentRequestsScreen({Key? key}) : super(key: key);

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
              Map map = snapshot.data!.data()?['sentRequests'];

              if(snapshot.data!.data()?['sentRequests'].length == 0) {
                return const Center(child: Text("لا يوجد طلبات مرسلة"));
              }

              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const BorderSide(
                          color: Colors.black87,
                          width: 0.1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      child: Padding(
                                        padding:const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.whatsapp,
                                          size: 30.0,
                                          color: HexColor('#7FB77E'),
                                        ),
                                      ),
                                      onTap: () {
                                        AppCubit.get(context).goToChatDetails(
                                          map.keys.toList()[index].toString(),
                                          context,
                                        );
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CacheHelper.savaData(key: 'latitude1', value: AppCubit.get(context).model.latitude);
                                        CacheHelper.savaData(key: 'longitude1', value: AppCubit.get(context).model.longitude);
                                        CacheHelper.savaData(key: 'name1', value: AppCubit.get(context).model.name);
                                        CacheHelper.savaData(key: 'latitude2', value: map[map.keys.toList()[index]]['latitude']);
                                        CacheHelper.savaData(key: 'longitude2', value:map[map.keys.toList()[index]]['longitude']);
                                        CacheHelper.savaData(key: 'name2', value: map[map.keys.toList()[index]]['name']);
                                        navigateTo(context, const GoogleMaps2());
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.black54,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          AppCubit.get(context).getDistance(
                                            lat1: AppCubit.get(context).model.latitude,
                                            long1: AppCubit.get(context).model.longitude,
                                            lat2: map[map.keys.toList()[index]]['latitude'],
                                            long2: map[map.keys.toList()[index]]['longitude'],
                                          ).toInt()==0?'يبعد عنك ${(AppCubit.get(context).getDistance(
                                            lat1: AppCubit.get(context).model.latitude,
                                            long1: AppCubit.get(context).model.longitude,
                                            lat2: map[map.keys.toList()[index]]['latitude'],
                                            long2: map[map.keys.toList()[index]]['longitude'],
                                          )*1000).toInt()} م':'يبعد عنك ${AppCubit.get(context).getDistance(
                                            lat1: AppCubit.get(context).model.latitude,
                                            long1: AppCubit.get(context).model.longitude,
                                            lat2: map[map.keys.toList()[index]]['latitude'],
                                            long2: map[map.keys.toList()[index]]['longitude'],
                                          ).toInt()} كم',
                                          style:const  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 20.0,),
                                        InkWell(
                                          child: Text(
                                            '${map[map.keys.toList()[index]]['name']}',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0
                                            ),
                                          ),
                                          onTap: () => navigateTo(context, ProfileScreen(
                                              id: map.keys.toList()[index],
                                              name: map[map.keys.toList()[index]]['name'])),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          ' يقيم في ${map[map.keys.toList()[index]]['location']}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0
                                          ),
                                        ),
                                        const SizedBox(width: 20.0),
                                        Text(
                                          '${map[map.keys.toList()[index]]['profession']}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0
                                          ),
                                        ),
                                        const SizedBox(width: 3.0),
                                        const Icon(Icons.workspace_premium, size: 20.0, color: Colors.green,),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8.0,),
                                InkWell(
                                  child: CircleAvatar(
                                    radius: 30.3,
                                    backgroundColor: Colors.black87,
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage('${map[map.keys.toList()[index]]['image']}'),
                                    ),
                                  ),
                                  onTap: () => navigateTo(context, ProfileScreen(
                                      id: map.keys.toList()[index],
                                      name: map[map.keys.toList()[index]]['name'])),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0,),
                            Text(
                            ' تفاصيل العمل: ${map[map.keys.toList()[index]]['details']}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  ' ${map[map.keys.toList()[index]]['deadline'][0]}-${map[map.keys.toList()[index]]['deadline'][1]}-${map[map.keys.toList()[index]]['deadline'][2]}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: map[map.keys.toList()[index]]['isDeadline']? Colors.red: Colors.green,
                                  ),
                                ),
                                const Text(
                                  ' :تاريخ الإنتهاء',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ' ${getStatus(
                                    isAccepted: map[map.keys.toList()[index]]['isAccepted'],
                                    isRejected: map[map.keys.toList()[index]]['isRejected']
                                  )}',
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.red
                                  ),
                                ),
                                const Text(
                                  ' :حالة الطلب ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>const SizedBox(height: 5.0,),
                  itemCount: snapshot.data!.data()?['sentRequests'].length,
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          },

        );
      },
    );
  }

}



String getStatus({
  required bool isAccepted,
  required bool isRejected,
}){
  if(isAccepted) {
    return "تم الموافقة من قبل الحِرَفِي";
  }
  if(isRejected) {
    return "تم الرفض من قبل الحِرَفِي";
  }
  return'في الإنتظار';
}
