// ignore_for_file: must_be_immutable
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/edit-profile/edit_profile_screen.dart';
import 'package:online_technician/modules/google_map2/GoogleMaps2.dart';
import 'package:online_technician/shared/components/components.dart';
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
          backgroundColor: HexColor('#ebebeb'),
            appBar: defaultAppBar(
              context: context,
              color: HexColor('#D6E4E5'),
              textColor: Colors.black87,
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
                            color: HexColor('#7286D3'),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: HexColor('#c6dfe7'),
                            borderRadius:const BorderRadius.only(
                              bottomRight: Radius.circular(50.0),
                              bottomLeft: Radius.circular(50.0),
                            ),
                          ),
                          child: Column(
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
                                            image: NetworkImage(snapshot.data!.data()!['coverImage'].toString()),
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
                                            backgroundColor: HexColor('#c6dfe7'),
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
                                                    color: Colors.black87,
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
                                        CacheHelper.savaData(key: 'latitude1', value: AppCubit.get(context).model.latitude);
                                        CacheHelper.savaData(key: 'longitude1', value: AppCubit.get(context).model.longitude);
                                        CacheHelper.savaData(key: 'name1', value: AppCubit.get(context).model.name);
                                        CacheHelper.savaData(key: 'latitude2', value: AppCubit.get(context).user?.latitude);
                                        CacheHelper.savaData(key: 'longitude2', value: AppCubit.get(context).user?.longitude);
                                        CacheHelper.savaData(key: 'name2', value: AppCubit.get(context).user?.name);
                                        navigateTo(context, GoogleMaps2());
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          const Icon(
                                            Icons.gps_fixed_rounded,
                                            color: Colors.lightGreen,
                                            size: 27.0,
                                          ),
                                          Text(
                                            snapshot.data!
                                                .data()!['location']
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17.0,
                                              color: Colors.lightGreen,
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
                                  ? Center(
                                    child: Padding(
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
                              ),
                                  )
                                  : const SizedBox(height: 10.0,),
                            ],
                          ),
                        ),
                        snapshot.data!.data()!['hasProfession'] == true?Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#80b0c8'),
                                borderRadius:const BorderRadius.only(
                                  bottomRight: Radius.circular(100.0),
                                  bottomLeft: Radius.circular(100.0),
                                ),
                            ),
                            child:const Padding(
                              padding: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 10.0, top: 2.0),
                              child: Text(
                                  ' أعمالي ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ):const SizedBox(),
                        const SizedBox(height: 20.0,),
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
                                itemBuilder: (context, index) => Card(
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
                                                    '${snapshot.data!.docs[index].data()['postImages'].length} من الأشخاص أعجبهم هذا...  ',
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
                                ),
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
