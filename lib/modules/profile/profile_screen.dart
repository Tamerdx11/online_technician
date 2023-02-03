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

  ProfileScreen({
    super.key,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AppCubit.get(context).model;

        return Scaffold(
            appBar: defaultAppBar(
              context: context,
              color: Colors.grey,
              title: '${userModel!.name}',
              textColor: Colors.black,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: OutlinedButton(
                    onPressed: () {
                      navigateTo(context, EditProfileScreen());
                    },
                    child: const Text(
                      'تعديل الملف الشخصي',
                      style: TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('person')
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 245.0,
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
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(snapshot.data!
                                        .data()!['coverImage']
                                        .toString()),
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
                                  padding: const EdgeInsets.only(top: 30.0),
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.black,
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
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: snapshot.data!.data()!['hasProfession'] != false
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                        snapshot.data!
                                            .data()!['profession']
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0,
                                          color: Colors.grey,
                                        )),
                                  ),
                                  const Text(
                                    '15.0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star_half_rounded,
                                    color: Colors.amberAccent,
                                  ),
                                  const SizedBox(
                                    width: 30.0,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                children: [
                                  Text(
                                    snapshot.data!
                                        .data()!['location']
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  const Icon(
                                    Icons.my_location,
                                    color: Colors.grey,
                                    size: 35.0,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            snapshot.data!.data()!['uId'] != uId
                                ? InkWell(
                                    onTap: () {
                                      ///go to chat
                                      AppCubit.get(context).goToChatDetails(
                                        snapshot.data!
                                            .data()!['uId']
                                            .toString(),
                                        context,
                                      );
                                    },
                                    child: Row(
                                      children: const [
                                        Text(
                                          'الدردشه',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Icon(
                                          Icons.wechat_sharp,
                                          color: Colors.grey,
                                          size: 40.0,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
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
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 1.0,
                          color: Colors.grey,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }
}
