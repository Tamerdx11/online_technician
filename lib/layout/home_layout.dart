import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/chats/chats_screen.dart';
import 'package:online_technician/modules/new-post/new_post_screen.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/modules/search/search_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

import '../modules/login/login_screen.dart';

// ignore: must_be_immutable
class AppLayout extends StatelessWidget {
  AppLayout({Key? key}) : super(key: key);

  List<String> titles = [
    'الصفحة الرئيسية',
    'الاشعارات',
    'الطلبات المرسلة',
    'الطلبات المستلمة',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: HexColor('#ebebeb'),
          drawer: cubit.currentIndex == 0
              ? Drawer(
                  backgroundColor: HexColor('#ebebeb'),
                  elevation: 40,
                  width: 200.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        curve: Curves.bounceInOut,
                        decoration: BoxDecoration(
                          color: HexColor('#0A81AB'),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40.5,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundImage:
                                    NetworkImage('${cubit.model?.userImage}'),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '${cubit.model?.name}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Center(
                          child:  Text(
                            'حسابي',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(context, ProfileScreen(
                            id: AppCubit.get(context).model.uId,
                            name: AppCubit.get(context).model.name,
                          ));

                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          height: .5,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.star_outlined,color: Colors.amber,),
                            SizedBox(width: 3.0,),
                            Text(
                              'قيم البرنامج ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          height: .5,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.headset_mic_outlined,color: Colors.black54,),
                            SizedBox(width: 3.0,),
                            Text(
                              'تواصل معنا ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          height: .5,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        title: const Center(
                          child: Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        onTap: () {
                          ///update state
                          CacheHelper.clearData(key: 'latitude1');
                          CacheHelper.clearData(key: 'longitude1');
                          CacheHelper.clearData(key: 'name1');
                          CacheHelper.clearData(key: 'latitude2');
                          CacheHelper.clearData(key: 'longitude2');
                          CacheHelper.clearData(key: 'name2');
                          CacheHelper.clearData(key: 'dis');
                          CacheHelper.clearData(key: 'phoneNumber');
                          CacheHelper.clearData(key: 'uId');
                          CacheHelper.clearData(key: 'hasProfession');
                          CacheHelper.clearData(key: 'onBoarding');
                          CacheHelper.clearData(key: 'imageUrl');
                          CacheHelper.clearData(key: 'token');
                          navigateToAndFinish(context, LoginScreen());
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          height: .5,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: HexColor('#0A81AB'),
            elevation: 3.0,
            centerTitle: true,
            title: Text(
              titles[cubit.currentIndex],
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoNaskhArabic',
                  fontWeight: FontWeight.w600,
              ),
            ),
            leading: cubit.currentIndex == 0
                ? Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: CircleAvatar(
                        radius: 20.2,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundImage:
                              NetworkImage('${cubit.model?.userImage}'),
                        ),
                      ),
                    );
                  })
                : null,
            actions: [
              if (cubit.currentIndex == 0)
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).search =[];
                    navigateTo(context, SearchScreen());
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white70,
                    size: 30.0,
                  ),
                ),
              const SizedBox(
                width: 1.0,
              ),
              if (cubit.currentIndex == 0)
                IconButton(
                  onPressed: () {
                    navigateTo(context, const ChatsScreen());
                    cubit.emit(AppGetchangeBageMessageState());
                  },
                  icon:
                      Badge(
                        badgeStyle:const BadgeStyle(
                          badgeColor: Colors.green,
                        ),
                        badgeContent:Text(
                          messagesNumber.toString(),
                          style:const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child:const  Icon(
                          Icons.chat,
                          color: Colors.white70,
                          size: 30.0,
                        ),
                      ),
                ),
              const SizedBox(
                width: 6.0,
              ),
            ],
          ),
          floatingActionButton: cubit.currentIndex == 0 && CacheHelper.getData(key: 'hasProfession') == true
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                    ),
                    child: FloatingActionButton(
                      elevation: 10.0,
                      onPressed: () {
                        navigateTo(context, NewPostScreen());
                      },
                      backgroundColor: HexColor('#0A81AB').withOpacity(0.60),
                      child: const Icon(
                          Icons.add_rounded,
                          size: 30.0,
                          color: Colors.white,
                      ),
                    ),
                  ),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 2.0,
            selectedItemColor: HexColor('#0A81AB'),
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeButtonNav(index);
            },
            items:CacheHelper.getData(key: 'hasProfession') == true? cubit.bottomItems1:cubit.bottomItems2,
          ),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}
