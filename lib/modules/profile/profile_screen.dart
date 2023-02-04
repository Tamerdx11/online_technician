// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/edit-profile/edit_profile_screen.dart';
import 'package:online_technician/modules/google_map2/GoogleMaps2.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class ProfileScreen extends StatelessWidget {
  String? id;
  String? name;

  ProfileScreen({
    super.key,
    this.id,
    this.name
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {


        return Scaffold(
            appBar: defaultAppBar(
              context: context,
              color: Colors.black26,
              textColor: Colors.black45,
              title: '$name',
              actions: [
                id == CacheHelper.getData(key: 'uId')?
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: OutlinedButton(
                      onPressed: () {
                        navigateTo(context, EditProfileScreen());},
                      child: const Text(
                        'تعديل',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                        ),
                      ),
                    ),
                  )
                    :IconButton(
                    onPressed: (){
                  AppCubit.get(context).goToChatDetails(
                    '$id',
                    context,
                  );
                },
                    icon:const Icon(
                      Icons.whatsapp_outlined,
                      color: Colors.black87,
                      size: 30.0,
                    ),
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('person')
                    .doc(id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('error 404'));
                  }
                  if (snapshot.hasData){
                    name = snapshot.data!.data()!['name'];
                    return Column(
                      children: [
                        SizedBox(
                          height: 235.0,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 160.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(50.0),
                                      bottomRight: Radius.circular(50.0),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(snapshot.data!.data()!['coverImage'].toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: CircleAvatar(
                                      radius: 66.0,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage: NetworkImage(snapshot
                                            .data!
                                            .data()!['userImage']
                                            .toString()),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 25.0, right: 25.0),
                                    height: 125.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data!
                                                .data()!['name']
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          child: snapshot.data!.data()!['hasProfession'] != false
                              ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                Row(
                                  children:const [
                                    Icon(
                                      Icons.star_half_rounded,
                                      color: Colors.amberAccent,
                                    ),
                                    Text(
                                      ' تقييم : 15.0',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(
                                        snapshot.data!
                                            .data()!['profession']
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                        )),
                                    const Text(
                                        ' :الحرفة',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.black87,
                                        )),
                                  ],
                                ),
                            ],
                          ),
                              )
                              : const Text(
                              "لا يقدم اي حرفة",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'يبعد عنك مسافة 13 كم',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 8.0,),
                              InkWell(
                                onTap: () async {
                                  await AppCubit.get(context).getUser(
                                      snapshot.data!.data()!['uId'].toString());
                                  var my = AppCubit.get(context).myuser[0];
                                  CacheHelper.savaData(
                                      key: 'latitude1', value: my.latitude);
                                  CacheHelper.savaData(
                                      key: 'longitude1', value: my.longitude);
                                  CacheHelper.savaData(
                                      key: 'name1', value: my.name);
                                  var thatuser = AppCubit.get(context).user[0];
                                  CacheHelper.savaData(
                                      key: 'latitude2', value: thatuser.latitude);
                                  CacheHelper.savaData(
                                      key: 'longitude2',
                                      value: thatuser.longitude);
                                  CacheHelper.savaData(
                                      key: 'name2', value: thatuser.name);
                                  print(
                                      '*******************************************');
                                  print(CacheHelper.getData(key: 'latitude1'));
                                  print(CacheHelper.getData(key: 'longitude1'));
                                  print(CacheHelper.getData(key: 'longitude2'));
                                  print(CacheHelper.getData(key: 'latitude2'));
                                  navigateTo(context, GoogleMaps2());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.gps_fixed_rounded,
                                      color: Colors.deepPurpleAccent,
                                      size: 27.0,
                                    ),
                                    Text(
                                      snapshot.data!
                                          .data()!['location']
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17.0,
                                        color: Colors.deepPurpleAccent,
                                        fontStyle: FontStyle.italic
                                      ),
                                    ),
                                    const Text(
                                      ' يقيم في ',
                                      style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        snapshot.data!.data()!['hasProfession'] != false
                            ? Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            overflow: TextOverflow.clip,
                            snapshot.data!.data()!['bio'].toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              overflow: TextOverflow.ellipsis,

                            ),
                          ),
                        )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 50.0),
                          child: Container(
                            height: 1.0,
                            color: Colors.grey,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.5, right: 50.0),
                          child: Container(
                            height: 1.0,
                            color: Colors.grey,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: LinearProgressIndicator(
                      color: Colors.grey,
                      backgroundColor: Colors.grey,
                    ),
                  );
                },
              ),
            ),
        );
      },
    );
  }
}
