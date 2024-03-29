import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/modules/report/report.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/styles/colors.dart';
import '../../shared/network/local/cache_helper.dart';
import '../google_map2/GoogleMaps2.dart';

enum _menuval{
  report,
}

enum MenuValuesMyPosts {
  delete,
}

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {

        return Container(
          color:  background_color,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('dateTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('error 404'));
                }
                if (snapshot.hasData) {
                  //AppCubit.get(context).requestsChecker();

                  return Column(
                    children: [
                      const SizedBox(
                        height: 13.0,
                      ),
                      ListView.separated(
                        padding:const EdgeInsets.symmetric(horizontal: 1.0),
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          int trueLikes = 0;
                          snapshot.data!.docs[index].data()['likes'].forEach(
                                (key, value) =>
                                    value == true ? trueLikes++ : trueLikes,
                              );
                          return Card(
                            color: post_color,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.05,
                                ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 2.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      snapshot.data!.docs[index]
                                                  .data()['uId'] == uId ?
                                      PopupMenuButton<MenuValuesMyPosts>(
                                        itemBuilder: (BuildContext context)=> [
                                          const PopupMenuItem(
                                            value: MenuValuesMyPosts.delete,
                                            child: Text('حذف'),
                                          ),
                                        ],
                                        onSelected: (value) async {
                                          switch(value){
                                            case MenuValuesMyPosts.delete:
                                              await FirebaseFirestore.instance.collection('posts').doc(snapshot.data!.docs[index].id).delete().then(
                                                      (onvalue) async {
                                                    showToast(text: ' تم الحذف بنجاح', state: ToastState.SUCCESS);
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
                                          : Row(
                                              children: [
                                                InkWell(
                                                  child: PopupMenuButton<_menuval>(itemBuilder: (BuildContext context)=>[
                                                    const PopupMenuItem(value: _menuval.report, child: Text("ابلاغ")),
                                                  ],
                                                  onSelected: (value){
                                                    switch (value){
                                                      case _menuval.report:
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
                                                InkWell(
                                                  onTap: () {
                                                    AppCubit.get(context)
                                                        .goToChatDetails(
                                                            snapshot.data!.docs[index].data()['uId'],
                                                            context,
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.whatsapp_rounded,
                                                    color: HexColor('#7FB77E'),
                                                    size: 27.0,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      .data()['name'],
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                ),
                                                onTap: () {
                                                  navigateTo(context, ProfileScreen(
                                                    id: snapshot.data!.docs[index]
                                                        .data()['uId'],
                                                    name:snapshot.data!.docs[index]
                                                        .data()['name'] ,
                                                  ));
                                                },
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        .data()['location'],
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
                                                    snapshot.data!.docs[index]
                                                        .data()['dateTime'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                      height: 1.6,
                                                      fontSize: 10,
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
                                      InkWell(
                                        child: CircleAvatar(
                                          radius: 22.1,
                                          backgroundColor:
                                              Colors.black,
                                          child: CircleAvatar(
                                            radius: 22.0,
                                            backgroundImage: NetworkImage(snapshot
                                                .data!.docs[index]
                                                .data()['userImage'].toString()),
                                          ),
                                        ),
                                        onTap: (){
                                          navigateTo(context, ProfileScreen(
                                            id: snapshot.data!.docs[index]
                                                .data()['uId'],
                                            name: snapshot.data!.docs[index]
                                                .data()['name'] ,
                                          ));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 90.0, right: 5.0, bottom: 1.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 0.1,
                                    color: HexColor('#453C67'),
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
                                    snapshot.data!.docs[index]
                                        .data()['postText'],
                                    style:const TextStyle(
                                      fontSize: 15,
                                    ),
                                    textDirection: TextDirection.rtl,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (snapshot.data!.docs[index]
                                    .data()['postImages']
                                    .isNotEmpty)
                                  CarouselSlider.builder(
                                    itemCount: snapshot.data!.docs[index]
                                        .data()['postImages']
                                        .length,
                                    itemBuilder: (BuildContext context,
                                            int itemIndex,
                                            int pageViewIndex) =>
                                        InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data!.docs[index]
                                                  .data()['postImages']
                                                      ['$itemIndex']
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
                                                        snapshot
                                                            .data!.docs[index]
                                                            .data()[
                                                                'postImages']
                                                                ['$itemIndex']
                                                            .toString(),
                                                      ),
                                                      fit: BoxFit.fill),
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
                                                '$trueLikes من الأشخاص أعجبهم هذا...  ',
                                                textDirection: TextDirection.rtl,
                                              style:const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3.0,
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 90.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 0.1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          AppCubit.get(context).likeChange(
                                            key: uId,
                                            postId: snapshot
                                                .data!.docs[index].id
                                                .toString(),
                                          );

                                        },
                                        enableFeedback: true,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.grey,
                                              width: 100.0,
                                              height: 0.1,
                                            ),
                                            const SizedBox(width: 25.0,),
                                            const Text(
                                              'أعجبني',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            snapshot.data!.docs[index]
                                                            .data()['likes']
                                                        [uId] ==
                                                    true
                                                ? Icon(
                                                    Icons.favorite_rounded,
                                                    color: HexColor('#F48484'),
                                                    size: 30.0,
                                                  )
                                                : Icon(
                                                    Icons.favorite_border,
                                                    color: HexColor('#F48484'),
                                                    size: 30.0,
                                                  ),
                                            const SizedBox(width: 25.0,),
                                            Container(
                                              color: Colors.grey,
                                              width: 100.0,
                                              height: 0.15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  );
                }
                return const Center(
                    child: LinearProgressIndicator(
                  color: Colors.teal,
                  backgroundColor: Colors.lightGreenAccent,
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
