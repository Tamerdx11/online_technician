import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({Key? key}) : super(key: key);
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
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
                      height: 15.0,
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
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 21.5,
                                      backgroundColor: Colors.green.withOpacity(0.5),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(snapshot
                                            .data!.docs[index]
                                            .data()['userImage']),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]
                                                .data()['name'],
                                          ),
                                          Row(
                                            children: [
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
                                              const SizedBox(
                                                width: 7.0,
                                              ),
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.red,
                                                size: 20.0,
                                              ),
                                              Text(
                                                snapshot.data!.docs[index]
                                                    .data()['location'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                      height: 1.6,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    snapshot.data!.docs[index].data()['uId'] ==
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
                                      children:[
                                        InkWell(
                                          onTap: (){},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.4),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            child:const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Icon(
                                                Icons.whatsapp_rounded,
                                                color: Colors.indigo,
                                                size: 25.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20.0,),
                                        InkWell(
                                          onTap: (){},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.4),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            child:const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Icon(
                                                Icons.my_location_outlined,
                                                color: Colors.indigo,
                                                size: 25.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0,),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                  ),
                                  child: myDivider(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 20.0,
                                  ),
                                  child: Text(
                                    snapshot.data!.docs[index].data()['postText'],
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                ),
                                if(snapshot.data!.docs[index].data()['postImages'].isNotEmpty)
                                  CarouselSlider.builder(
                                    itemCount: snapshot.data!.docs[index].data()['postImages'].length,
                                    itemBuilder: (BuildContext context, int itemIndex,
                                        int pageViewIndex) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),
                                        image: DecorationImage(
                                          image: NetworkImage(snapshot.data!.docs[index].data()['postImages']['$itemIndex'].toString(),),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
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
                                const SizedBox(height: 5.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.favorite_border_rounded,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(trueLikes.toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: 35.0,
                                    top: 5.0,
                                    bottom: 8.0
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 1.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                InkWell(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      snapshot.data!.docs[index].data()['likes']
                                                  [uId] ==
                                              true
                                          ? const Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Love',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    AppCubit.get(context).likeChange(
                                      key: uId,
                                      postId: snapshot.data!.docs[index].id
                                          .toString(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                );
              }
              return const Center(child: LinearProgressIndicator());
            },
          ),
        );
      },
    );
  }
}

