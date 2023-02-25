// ignore_for_file: must_be_immutable
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/edit-profile/edit_profile_screen.dart';
import 'package:online_technician/modules/google_map2/GoogleMaps2.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

import '../send_request_to_tech/send_request_to_tech_screen.dart';

class ProfileScreen extends StatelessWidget {
  String id;
  String name;

  ProfileScreen({
    super.key,
    required this.id,
    required this.name
  });
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {

        return Scaffold(
          backgroundColor: HexColor('#F9F9F9'),
            appBar: defaultAppBar(
              context: context,
              color: HexColor('#0A81AB'),
              textColor: Colors.white,
              title: '$name',
              actions: [
                id == CacheHelper.getData(key: 'uId')?
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: OutlinedButton(
                      onPressed: () {
                        navigateTo(context, EditProfileScreen());
                        },
                      child: Text(
                        'تعديل',
                        style: TextStyle(
                            color: HexColor('#A5E1AD'),
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
            body: SingleChildScrollView(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          margin:const EdgeInsets.all(0),
                          elevation: 5.0,
                          shape: const OutlineInputBorder(
                            borderRadius:BorderRadius.only(
                              bottomRight: Radius.circular(50.0),
                              bottomLeft: Radius.circular(50.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 0.05,
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 280.0,
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
                                            image: NetworkImage(snapshot.data!.data()!['coverImage'].toString()),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 30.0,
                                        ),
                                        CircleAvatar(
                                          radius: 66.0,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 60.3,
                                            backgroundColor: Colors.black,
                                            child: CircleAvatar(
                                              radius: 60.0,
                                              backgroundImage: NetworkImage(snapshot
                                                  .data!
                                                  .data()!['userImage']
                                                  .toString()),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(top: 35.0, right:0.0),
                                            height: 180.0,
                                            child: Padding(
                                              padding: const EdgeInsets.all(30.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshot.data!
                                                        .data()!['name']
                                                        .toString(),
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 20.0,
                                                      color: Colors.black87,
                                                      overflow: TextOverflow.clip,
                                                    ),
                                                  ),
                                                  if(snapshot.data!.data()!['hasProfession'] == true)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                            snapshot.data!
                                                                .data()!['profession']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14.0,
                                                                color: Colors.grey,
                                                                fontStyle: FontStyle.italic
                                                            )),
                                                        const SizedBox(width: 2.0,),
                                                        const Icon(Icons.handyman_sharp, size: 17.0, color: Colors.black54,),
                                                      ],
                                                    ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      if(id != CacheHelper.getData(key: 'uId'))
                                                        Text(
                                                          AppCubit.get(context).getDistance(
                                                            lat1: AppCubit.get(context).model.latitude,
                                                            long1: AppCubit.get(context).model.longitude,
                                                            lat2: snapshot.data!.data()!['latitude'],
                                                            long2: snapshot.data!.data()!['longitude'],
                                                          ).toInt()==0?'يبعد عنك ${(AppCubit.get(context).getDistance(
                                                            lat1: AppCubit.get(context).model.latitude,
                                                            long1: AppCubit.get(context).model.longitude,
                                                            lat2: snapshot.data!.data()!['latitude'],
                                                            long2: snapshot.data!.data()!['longitude'],
                                                          )*1000).toInt()} م':'يبعد عنك ${AppCubit.get(context).getDistance(
                                                            lat1: AppCubit.get(context).model.latitude,
                                                            long1: AppCubit.get(context).model.longitude,
                                                            lat2: snapshot.data!.data()!['latitude'],
                                                            long2: snapshot.data!.data()!['longitude'],
                                                          ).toInt()} كم',
                                                          style:const  TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12.0,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      if(id != CacheHelper.getData(key: 'uId'))
                                                         Padding(
                                                           padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                           child: Container(
                                                             width: 1.0,
                                                             height: 20.0,
                                                             color: Colors.black54,
                                                           ),
                                                         ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            snapshot.data!
                                                                .data()!['location']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 12.0,
                                                                color: Colors.grey,
                                                                fontStyle: FontStyle.italic
                                                            ),
                                                          ),
                                                          const Icon(
                                                            Icons.gpp_good_sharp,
                                                            color: Colors.green,
                                                            size: 18.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if(snapshot.data!.data()!['hasProfession'] == true)
                                Center(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                    child: Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            overflow: TextOverflow.clip,
                                            snapshot.data!.data()!['bio'].toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0,
                                              overflow: TextOverflow.ellipsis,

                                            ),
                                          ),
                                          const SizedBox(width: 10.0,),
                                          const Icon(Icons.edit_note_rounded, color: Colors.grey,size: 20.0,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(snapshot.data!.data()!['hasProfession'] == true)
                                      Expanded(
                                      child: Column(
                                        children: const [
                                          Text(
                                            'تقييم المهارة',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Text(
                                            '7.9',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                    await AppCubit.get(context).getUser(
                                    snapshot.data!.data()!['uId'].toString());
                                    CacheHelper.savaData(key: 'latitude1', value: AppCubit.get(context).model.latitude);
                                    CacheHelper.savaData(key: 'longitude1', value: AppCubit.get(context).model.longitude);
                                    CacheHelper.savaData(key: 'name1', value: AppCubit.get(context).model.name);
                                    CacheHelper.savaData(key: 'latitude2', value: AppCubit.get(context).user?.latitude);
                                    CacheHelper.savaData(key: 'longitude2', value: AppCubit.get(context).user?.longitude);
                                    CacheHelper.savaData(key: 'name2', value: AppCubit.get(context).user?.name);
                                    navigateTo(context, GoogleMaps2());
                                    },
                                      child: Container(
                                        width: 40,
                                        height: 47.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.green,
                                        ),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.redAccent.withOpacity(0.8),
                                          size: 25.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5.0,),
                                    ///===== add طلب للعمل
                                    if(snapshot.data!.data()!['hasProfession'] == true && snapshot.data!.data()!['uId'] != AppCubit.get(context).model.uId)
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.green,
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {
                                            ///navigation here
                                            navigateTo(context, SendRequestToTechScreen(
                                              id: id,
                                              name: snapshot.data!.data()!['name'],
                                              token: snapshot.data!.data()!['token'],
                                              receivedRequests: snapshot.data!.data()!['receivedRequests'],
                                              userImage: snapshot.data!.data()!['userImage'],
                                              latitude: snapshot.data!.data()!['latitude'],
                                              longitude:  snapshot.data!.data()!['longitude'],
                                              location: snapshot.data!.data()!['location'],
                                            ));
                                          },
                                          child: Row(
                                            children:const [
                                              Icon(
                                                Icons.work_history,
                                                color: Colors.lightGreenAccent,
                                                size: 25.0,
                                              ),
                                              SizedBox(width: 8.0,),
                                              Text(
                                                'طلب للعمل',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.black87,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),

                                        ),
                                      ),
                                    const SizedBox(width: 25.0,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0,),
                        StreamBuilder(
                          stream:  FirebaseFirestore.instance
                              .collection('posts')
                              .where("uId", isEqualTo: id).snapshots(),
                          builder: (context, snapshot) {

                            if (snapshot.hasError) {
                              return const Center(child: Text('error 404'));
                            }
                            if(snapshot.hasData){
                              return ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  int trueLikes = 0;
                                  snapshot.data!.docs[index].data()['likes'].forEach(
                                        (key, value) =>
                                    value == true ? trueLikes++ : trueLikes,
                                  );
                                  return Card(
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 0.05,
                                    ),),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 3.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                /// update post
                                                /// delete post
                                              },
                                              icon: const Icon(
                                                Icons.more_horiz,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      snapshot.data!.docs[index].data()['name'].toString(),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                      textDirection:
                                                      TextDirection.rtl,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          snapshot.data!.docs[index].data()['location'].toString(),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .caption!
                                                              .copyWith(
                                                            color: Colors.grey,
                                                            height: 1.6,
                                                          ),
                                                          textDirection:
                                                          TextDirection.rtl,
                                                        ),
                                                        const Icon(
                                                          Icons.where_to_vote,
                                                          color: Colors.grey,
                                                          size: 17.0,
                                                        ),
                                                        const SizedBox(
                                                          width: 7.0,
                                                        ),
                                                        Text(
                                                          snapshot.data!.docs[index].data()['dateTime'].toString(),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .caption!
                                                              .copyWith(
                                                            height: 1.6,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            CircleAvatar(
                                              radius: 21.2,
                                              backgroundColor: Colors.black,
                                              child: CircleAvatar(
                                                radius: 21.0,
                                                backgroundImage: NetworkImage(
                                                  snapshot.data!.docs[index].data()['userImage'].toString(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 80.0, right: 5.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 0.1,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 5.0,
                                          bottom: 20.0,
                                        ),
                                        child: Text(
                                          snapshot.data!.docs[index].data()['postText'].toString(),
                                          style:const TextStyle(
                                            fontSize: 15,
                                          ),
                                          textDirection: TextDirection.rtl,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (snapshot.data!.docs[index].data()['postImages']!.isNotEmpty)
                                        CarouselSlider.builder(
                                          itemCount: snapshot.data!.docs[index].data()['postImages'].length,
                                          itemBuilder: (BuildContext context,
                                              int itemIndex,
                                              int pageViewIndex) =>
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        snapshot.data!.docs[index].data()['postImages']!['$itemIndex']
                                                            .toString(),
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  width: double.infinity,
                                                ),
                                                onTap: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => Dialog(
                                                        insetPadding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 5.0),
                                                        insetAnimationCurve:
                                                        Curves.easeInOut,
                                                        insetAnimationDuration:
                                                        const Duration(
                                                            milliseconds: 1500),
                                                        child: Container(
                                                          height: 400.0,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: NetworkImage(
                                                                snapshot.data!.docs[index].data()['postImages']!['$itemIndex']
                                                                    .toString(),
                                                              ),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        )),
                                                  );
                                                },
                                              ),
                                          options: CarouselOptions(
                                            enlargeCenterPage: true,
                                            viewportFraction: 0.85,
                                            autoPlay: false,
                                            aspectRatio: 1.0,
                                            height: 300,
                                            enableInfiniteScroll: false,
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${trueLikes} من الأشخاص أعجبهم هذا... ',
                                                    textDirection: TextDirection.rtl,
                                                    style:const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Icon(
                                                    Icons.favorite,
                                                    color: HexColor('#F48484'),
                                                    size: 27.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                    ],
                                  ),
                                );
                                  },
                                separatorBuilder: (context, index) => const SizedBox(height: 3.0,),
                                itemCount: snapshot.data!.docs.length,
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(height: 20.0,),
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
