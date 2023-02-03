import 'package:conditional_builder/conditional_builder.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:carousel_slider/carousel_slider.dart';

// ignore: must_be_immutable
class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);
  var textController = TextEditingController();
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context).model;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title:Text("اضافة بوست",style: TextStyle(color: Colors.black,fontFamily: 'NotoNaskhArabic',fontWeight: FontWeight.w600)),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:const Icon(Icons.arrow_back_sharp,color: Colors.black,),
              )),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
              child: Card(
                elevation: 0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Colors.black,width: .3,)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (state is AppCreatePostLoadingState)
                        const LinearProgressIndicator(),
                      if (state is AppCreatePostLoadingState)
                        const SizedBox(
                          height: 5.0,
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${cubit.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,fontSize: 16,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      cubit?.location,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            height: 1.6,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                      size: 20.0,
                                    ),
                                    const SizedBox(
                                      width: 7.0,
                                    ),
                                    Text(
                                      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                        height: 1.6,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            radius: 27,
                            backgroundColor: Colors.green.withOpacity(0.5),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                              NetworkImage('${cubit?.userImage}'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: "اكتب نبذة عن اعمالك...",
                          border: InputBorder.none,
                          hintTextDirection: TextDirection.rtl,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      if(AppCubit.get(context).postImageFile.isNotEmpty)
                        TextButton(onPressed: () {
                          if(AppCubit.get(context).curr_index > 0) {
                            AppCubit.get(context).removePostImage(index: AppCubit.get(context).curr_index);
                            AppCubit.get(context).changeCarousel(AppCubit.get(context).curr_index-1);

                          }
                          else{
                            AppCubit.get(context).removePostImage(index: AppCubit.get(context).curr_index);
                          }

                        },
                          child:Row(
                            children:const [
                              Spacer(),
                              Icon(Icons.highlight_remove,size: 32.0,color: Colors.redAccent,),
                            ],
                          ),
                        ),
                      if(AppCubit.get(context).postImageFile.isNotEmpty)
                        CarouselSlider.builder(
                          carouselController: _controller,
                          itemCount: AppCubit.get(context).postImageFile.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) => Container(
                            height: 80.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              image: DecorationImage(
                                image: FileImage(AppCubit.get(context).postImageFile[itemIndex]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            viewportFraction: 1.0,
                            autoPlay: false,
                            aspectRatio: 2.0,
                            height: 250,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              _controller.jumpToPage(index);
                              AppCubit.get(context).changeCarousel(index) ;
                            },
                          ),
                        ),
                      if(AppCubit.get(context).postImageFile.isNotEmpty)
                        const SizedBox(height: 3.0,),
                      if(AppCubit.get(context).postImageFile.isNotEmpty)
                        DotsIndicator(
                          dotsCount: AppCubit.get(context).postImageFile.length,
                          position: AppCubit.get(context).curr_index.toDouble(),
                          decorator: DotsDecorator(
                            size: const Size.square(9.0),
                            activeSize: const Size(18.0, 9.0),
                            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            spacing: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                          ), // decorator: ,
                        ),

                      // Column(
                      //   children: [
                      //     CarouselSlider(
                      //         items: [
                      //           Image.network('https://pixlr.com/images/index/remove-bg.webp',fit: BoxFit.cover, width: double.infinity,),
                      //           Image.network('https://pixlr.com/images/index/remove-bg.webp',fit: BoxFit.cover, width: double.infinity,),
                      //           Image.network('https://pixlr.com/images/index/remove-bg.webp',fit: BoxFit.cover, width: double.infinity,),
                      //         ],
                      //         options: CarouselOptions(
                      //           scrollPhysics: ClampingScrollPhysics(),
                      //             // enlargeCenterPage: true,
                      //             viewportFraction: 1,
                      //             aspectRatio: 2.0,
                      //             height: 250,
                      //             enableInfiniteScroll: false
                      //         ),
                      //       carouselController: _controller,
                      //     ),
                      //     RaisedButton(
                      //       onPressed: () => buttonCarouselController.nextPage(
                      //           duration: Duration(milliseconds: 300), curve: Curves.linear),
                      //       child: Text('→'),
                      //     )
                      //   ],
                      // ),

                      // Column(
                      //   children: [
                      //     ListView.builder(
                      //       itemCount: AppCubit.get(context).len,
                      //       itemBuilder: (context, index) => Stack(
                      //         alignment: AlignmentDirectional.topEnd,
                      //         children: [
                      //           Container(
                      //             height: 80.0,
                      //             width: 80.0,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(4.0),
                      //               image: DecorationImage(
                      //                 image: FileImage(
                      //                     AppCubit.get(context).postImageFile!.first),
                      //                 fit: BoxFit.cover,
                      //               ),
                      //             ),
                      //           ),
                      //           IconButton(
                      //             onPressed: () {
                      //               AppCubit.get(context).removePostImage(index: index);
                      //             },
                      //             icon: CircleAvatar(
                      //               backgroundColor: Colors.black.withOpacity(0.4),
                      //               child: const Icon(
                      //                 Icons.close,
                      //                 color: Colors.white,
                      //                 size: 15.0,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: double.infinity,
                          height: .1,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                AppCubit.get(context).getPostImage();
                              },
                              icon: const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 25.0,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                AppCubit.get(context).getPostImageCamera();
                              },
                              icon: const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 25.0,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                if (textController.text.isEmpty &&
                                    AppCubit.get(context).postImageFile.isEmpty)
                                {
                                  showToast(
                                      text: 'empty post',
                                      state: ToastState.ERROR);
                                }
                                else if(AppCubit.get(context).postImageFile.isNotEmpty)
                                {
                                  AppCubit.get(context).uploadPostImage(
                                    context: context,
                                    text: textController.text,
                                    dateTime:
                                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                                  );
                                }
                                else
                                {
                                  print('only text -------------------------');
                                  AppCubit.get(context).createPost(
                                    context: context,
                                    text: textController.text,
                                    dateTime:
                                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.black,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 22.0),
                                  child: Text('شارك اعمالك الان',textDirection: TextDirection.rtl,style: TextStyle(color: Colors.white,fontSize: 16)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
