// ignore_for_file: must_be_immutable
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/edit-profile/edit_profile_screen.dart';
import 'package:online_technician/modules/google_map2/GoogleMaps2.dart';
import 'package:online_technician/modules/report/report.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';
import 'package:online_technician/shared/styles/colors.dart';

import '../send_request_to_tech/send_request_to_tech_screen.dart';
enum MenuValue{
  report,
}

enum MenuValuesMyPostsProfile {
  delete,
}

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
          backgroundColor: background_color,
            appBar: defaultAppBar(
              context: context,
              color: header_color,
              textColor: Colors.white,
              elevation: 2.0,
              arrowColor: Colors.white,
              title: 'الصفحة شخصية',
              actions: [
                if(id == CacheHelper.getData(key: 'uId'))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                    child: MaterialButton(
                      elevation: 4.0,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        navigateTo(context, EditProfileScreen());
                        },
                      child:const Text(
                        'تعديل',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
                            child: Card(
                              color: Colors.white,
                              margin:const EdgeInsets.all(0),
                              elevation: 8.0,
                              shape:const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.6,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height:25.0),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        width: 35.0,
                                      ),
                                      Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                .data!
                                                .data()!['userImage']
                                                .toString()),
                                            fit: BoxFit.fill,
                                          ),
                                          border: Border.all(
                                            color: Colors.black87,
                                            width: 0.5,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100.0)
                                          )
                                        ),
                                      ),
                                      const SizedBox(height: 4.0,),
                                      Column(
                                        children: [
                                          Text(
                                            snapshot.data!
                                                .data()!['name']
                                                .toString(),
                                            maxLines: 1,
                                            style:const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 23.0,
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
                                                        fontSize: 15.0,
                                                        color: Colors.black54,
                                                        fontStyle: FontStyle.italic
                                                    )),
                                                const SizedBox(width: 5.0,),
                                                Icon(
                                                  Icons.handyman_sharp,
                                                  size: 18.0,
                                                  color: header_color,
                                                ),
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
                                                    fontSize: 13.0,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              if(id != CacheHelper.getData(key: 'uId'))
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
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
                                                        fontSize: 13.0,
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
                                    ],
                                  ),
                                  const SizedBox(height: 15.0,),
                                  if(snapshot.data!.data()!['hasProfession'] == true && snapshot.data!.data()!['uId'] != AppCubit.get(context).model.uId)
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              AppCubit.get(context).goToChatDetails(
                                                id.toString(),
                                                context,
                                              );
                                            },
                                            child: Container(
                                              width: 50,
                                              height: 47.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: header_color,
                                              ),
                                              child:const Icon(
                                                Icons.whatsapp_sharp,
                                                color: Colors.white,
                                                size: 25.0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8.0,),
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
                                              width: 50,
                                              height: 47.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: header_color,
                                              ),
                                              child:const Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                                size: 25.0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8.0,),
                                          Container(
                                            width: 180.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              color: header_color,
                                            ),
                                            child: MaterialButton(
                                              onPressed: () {
                                                ///navigation here
                                                navigateTo(context, SendRequestToTechScreen(
                                                  id: id,
                                                  name: snapshot.data!.data()!['name'],
                                                  profession: snapshot.data!.data()!['profession'],
                                                  token: snapshot.data!.data()!['token'],
                                                  receivedRequests: snapshot.data!.data()!['receivedRequests'],
                                                  userImage: snapshot.data!.data()!['userImage'],
                                                  latitude: snapshot.data!.data()!['latitude'],
                                                  longitude:  snapshot.data!.data()!['longitude'],
                                                  location: snapshot.data!.data()!['location'],
                                                ));
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children:const [
                                                  Icon(
                                                    Icons.work_history,
                                                    color: Colors.white,
                                                    size: 25.0,
                                                  ),
                                                  SizedBox(width: 18.0,),
                                                  Text(
                                                    'طلب للعمل',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(snapshot.data!.data()!['positive'].toString().isNotEmpty || snapshot.data!.data()!['neutral'].toString().isNotEmpty || snapshot.data!.data()!['negative'].toString().isEmpty)
                                    Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children:  [
                                        const SizedBox(height: 12.0,),
                                        const Text(
                                          'تقييمات الأعمال السابقة',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black87,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const SizedBox(height: 5.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Spacer(),
                                            Card(
                                              color: HexColor('#A4D0A4'),
                                              shape:const OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(20.0),
                                                  topLeft: Radius.circular(20.0),
                                                  bottomLeft: Radius.circular(20.0),
                                                  topRight: Radius.circular(20.0),
                                                ),
                                                borderSide: BorderSide(
                                                  color: Colors.lightGreen,
                                                  width: 0.2,
                                                ),
                                              ),
                                              elevation: 8.0,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children:  [
                                                    const Text(
                                                      ' ممتاز ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10.0,),
                                                    Text(
                                                      ' ${snapshot.data!
                                                          .data()!['positive']
                                                          .toString().isNotEmpty?snapshot.data!
                                                          .data()!['positive']
                                                          .toString():"0"} ',
                                                      style:const TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Card(
                                              color: HexColor('#F3E99F'),
                                              shape:const OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(20.0),
                                                  topLeft: Radius.circular(20.0),
                                                  bottomLeft: Radius.circular(20.0),
                                                  topRight: Radius.circular(20.0),
                                                ),
                                                borderSide: BorderSide(
                                                  color: Colors.yellowAccent,
                                                  width: 0.2,
                                                ),
                                              ),
                                              elevation: 8.0,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children:  [
                                                    const Text(
                                                      ' جيد ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10.0,),
                                                    Text(
                                                      ' ${snapshot.data!
                                                          .data()!['neutral']
                                                          .toString().isNotEmpty?snapshot.data!
                                                          .data()!['neutral']
                                                          .toString():"0"}',
                                                      style:const TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Card(
                                              color: HexColor('#FF6D60'),
                                              shape:const OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(20.0),
                                                  topLeft: Radius.circular(20.0),
                                                  bottomLeft: Radius.circular(20.0),
                                                  topRight: Radius.circular(20.0),
                                                ),
                                                borderSide: BorderSide(
                                                  color: Colors.redAccent,
                                                  width: 0.2,
                                                ),
                                              ),
                                              elevation: 8.0,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children:  [
                                                    const Text(
                                                      ' سيئ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10.0,),
                                                    Text(
                                                      '${snapshot.data!
                                                          .data()!['negative']
                                                          .toString().isNotEmpty?snapshot.data!
                                                          .data()!['negative']
                                                          .toString():"0"} ',
                                                      style:const TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        )

                                      ],
                                    ),
                                  )
                                  else
                                    const Padding(
                                      padding:  EdgeInsets.only( top: 12.0),
                                      child:  Center(
                                        child: Text(
                                          'لم يتم تقييمه بعد',
                                          style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if(snapshot.data!.data()!['hasProfession'] == true)
                                    Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              overflow: TextOverflow.clip,
                                              snapshot.data!.data()!['bio'].toString(),
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,

                                              ),
                                            ),
                                            const SizedBox(width: 5.0,),
                                            const Icon(
                                              Icons.edit_note_rounded,
                                              color: Colors.black,
                                              size: 25.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if(snapshot.data!.data()!['hasProfession'] == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 13.0, bottom: 13.0, right: 8.0),
                              child: Card(
                                color: header_color,
                                margin:const EdgeInsets.all(0),
                                elevation: 5.0,
                                shape: OutlineInputBorder(
                                  borderRadius:const BorderRadius.only(
                                    topLeft: Radius.circular(80.0),
                                    bottomLeft: Radius.circular(80.0),
                                    topRight: Radius.circular(80.0),
                                    bottomRight: Radius.circular(80.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: HexColor('#1d2021'),
                                    width: 0.05,
                                  ),
                                ),
                                child:const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                                  child:  Text(
                                      'أعمال سابقة',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white
                                    ),
                                  ),
                                ),

                              ),
                            ),
                          const SizedBox(height: 15.0,),
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
                                              snapshot.data!.docs[index]
                                                  .data()['uId'] == uId ?
                                              PopupMenuButton<MenuValuesMyPostsProfile>(
                                                itemBuilder: (BuildContext context)=> [
                                                  const PopupMenuItem(
                                                    value: MenuValuesMyPostsProfile.delete,
                                                    child: Text('حذف البوست'),
                                                  ),
                                                ],
                                                onSelected: (value) async {
                                                  switch(value){
                                                    case MenuValuesMyPostsProfile.delete:
                                                      await FirebaseFirestore.instance.collection('posts').doc(snapshot.data!.docs[index].id).delete().then(
                                                              (onvalue) async {
                                                            showToast(text: 'تم الحذف', state: ToastState.SUCCESS);
                                                          }
                                                      );
                                                      for(int i=0;i<snapshot.data!.docs[index]['postImages'].toString().length;i++) {
                                                        await FirebaseStorage.instance
                                                            .refFromURL(snapshot.data!
                                                            .docs[index]['postImages']['$i'])
                                                            .delete()
                                                            .then((value) {
                                                          print(snapshot.data!
                                                              .docs[index]['postImages']['$i']);
                                                        });
                                                      }
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.more_horiz,
                                                ),
                                                position: PopupMenuPosition.under,
                                              )
                                                  :Row(
                                                children: [
                                                  InkWell(
                                                    child: PopupMenuButton<MenuValue>(itemBuilder: (BuildContext context)=>[
                                                      const PopupMenuItem(value: MenuValue.report, child: Text("ابلاغ")),
                                                    ],
                                                      onSelected: (value){
                                                        switch (value){
                                                          case MenuValue.report:
                                                            navigateTo(context, ReportScreen(
                                                              reportUserId:snapshot.data!.docs[index].data()['uId'] ,
                                                              reportUsername: snapshot.data!.docs[index].data()['name'],
                                                            ));
                                                            break;
                                                        }
                                                      },
                                                      position: PopupMenuPosition.under,
                                                      icon: const Icon(Icons.more_horiz,size: 25),
                                                    ),

                                                  ),
                                                ],
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
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        children: [
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
            ),
        );
      },
    );
  }
}
