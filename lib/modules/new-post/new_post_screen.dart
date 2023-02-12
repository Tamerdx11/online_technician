import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
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
          backgroundColor: HexColor('#FAF7F0'),
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: HexColor('#D6E4E5'),
              elevation: 3.0,
              title:const Text(
                  "اضافة بوست",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'NotoNaskhArabic',
                      fontWeight: FontWeight.w600,
                  ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:const Icon(Icons.arrow_back_sharp,color: Colors.black,),
              ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 7.0),
              child: Card(
                elevation: 3.0,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.1,
                    ),
                ),
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
                                      Icons.where_to_vote,
                                      color: Colors.grey,
                                      size: 17.0,
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
                            radius: 23.1,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 23,
                              backgroundImage:
                              NetworkImage('${cubit?.userImage}'),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 90.0, right: 5.0, bottom: 6.0, top: 4.0),
                        child: Container(
                          width: double.infinity,
                          height: 0.1,
                          color: HexColor('#453C67'),
                        ),
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
                          itemBuilder: (
                              BuildContext context,
                              int itemIndex,
                              int pageViewIndex,) => Container(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 90.0, bottom: 6.0, top: 4.0),
                        child: Container(
                          width: double.infinity,
                          height: 0.1,
                          color: HexColor('#453C67'),
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
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                AppCubit.get(context).getPostImageCamera();
                              },
                              icon: const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 25.0,
                                color: Colors.blueAccent,
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
                                  color: HexColor('#76BA99'),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 22.0),
                                  child: Text(
                                      'شارك ألان',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                      ),
                                  ),
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
