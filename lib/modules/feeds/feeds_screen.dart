import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import '../../shared/network/local/cache_helper.dart';
import '../google_map2/GoogleMaps2.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          color: Colors.white10,
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
                  return Column(
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      ListView.separated(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          int trueLikes = 0;
                          snapshot.data!.docs[index].data()['likes'].forEach(
                                (key, value) =>
                                    value == true ? trueLikes++ : trueLikes,
                              );
                          return Card(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: .3,
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
                                                  .data()['uId'] ==
                                              uId
                                          ? IconButton(
                                              onPressed: () {
                                                /// update post
                                                /// delete post
                                              },
                                              icon: const Icon(
                                                Icons.more_horiz,
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    AppCubit.get(context)
                                                        .goToChatDetails(
                                                            snapshot.data!.docs[index].data()['uId'],
                                                            context,
                                                    );
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(6.0),
                                                    child: Icon(
                                                      Icons.whatsapp_sharp,
                                                      color: Colors.black87,
                                                      size: 27.0,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 1.0,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    await AppCubit.get(context).getUser(snapshot
                                                            .data!.docs[index]
                                                            .data()['uId']);
                                                    CacheHelper.savaData(
                                                        key: 'latitude1',
                                                        value: AppCubit.get(context).model.latitude);
                                                    CacheHelper.savaData(
                                                        key: 'longitude1',
                                                        value: AppCubit.get(context).model.longitude);
                                                    CacheHelper.savaData(
                                                        key: 'name1',
                                                        value: AppCubit.get(context).model.name);
                                                    CacheHelper.savaData(
                                                        key: 'latitude2',
                                                        value:
                                                        AppCubit.get(context).user?.latitude);
                                                    CacheHelper.savaData(
                                                        key: 'longitude2',
                                                        value:
                                                        AppCubit.get(context).user?.longitude);
                                                    CacheHelper.savaData(
                                                        key: 'name2',
                                                        value: AppCubit.get(context).user?.name);
                                                    print(
                                                        '*******************************************');
                                                    print(CacheHelper.getData(
                                                        key: 'latitude1'));
                                                    print(CacheHelper.getData(
                                                        key: 'longitude1'));
                                                    print(CacheHelper.getData(
                                                        key: 'longitude2'));
                                                    print(CacheHelper.getData(
                                                        key: 'latitude2'));
                                                    navigateTo(
                                                        context, GoogleMaps2());
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(6.0),
                                                    child: Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Colors.black,
                                                      size: 27.0,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
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
                                              InkWell(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      .data()['name'],
                                                  style: const TextStyle(
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
                                                  const SizedBox(
                                                    width: 7.0,
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        .data()['dateTime'],
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
                                      InkWell(
                                        child: CircleAvatar(
                                          radius: 21.5,
                                          backgroundColor:
                                              Colors.green.withOpacity(0.5),
                                          child: CircleAvatar(
                                            radius: 20,
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
                                Container(
                                  width: double.infinity,
                                  height: 0.3,
                                  color: Colors.black,
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
                                                fontSize: 12.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              Icons.favorite,
                                              color: Colors.black87,
                                              size: 30.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 0.2,
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
                                                ? const Icon(
                                                    Icons.favorite_rounded,
                                                    color: Colors.black87,
                                                    size: 32.0,
                                                  )
                                                : const Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.black87,
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
                          height: 10,
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                    child: LinearProgressIndicator(
                  color: Colors.teal,
                  backgroundColor: Colors.white,
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
