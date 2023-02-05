import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/chats/chats_screen.dart';
import 'package:online_technician/modules/new-post/new_post_screen.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/modules/search/search_screen.dart';
import 'package:online_technician/modules/settings/settings_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

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
          drawer: cubit.currentIndex == 0
              ? Drawer(
                  backgroundColor: Colors.white,
                  elevation: 40,
                  width: 230.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        curve: Curves.bounceInOut,
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 46.5,
                              backgroundColor:Colors.greenAccent,
                              child: CircleAvatar(
                                radius: 45.0,
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
                            'الملف الشخصي',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
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
                        title:const Center(
                          child: Text(
                            'الاعدادات',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(context, SettingsScreen());
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
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        onTap: () {
                          ///update state
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              : null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 3.5,
            centerTitle: true,
            title: Text(
              titles[cubit.currentIndex],
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'NotoNaskhArabic',
                  fontWeight: FontWeight.w600),
            ),
            leading: cubit.currentIndex == 0
                ? Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: CircleAvatar(
                        radius: 18.0,
                        backgroundImage:
                            NetworkImage('${cubit.model?.userImage}'),
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
                  icon: const Icon(Icons.search_rounded, color: Colors.black),
                ),
              const SizedBox(
                width: 3.0,
              ),
              if (cubit.currentIndex == 0)
                IconButton(
                  onPressed: () {
                    navigateTo(context, const ChatsScreen());
                    AppCubit.get(context).getUsers();
                  },
                  icon:
                      const Icon(Icons.messenger_outline, color: Colors.black),
                ),
              const SizedBox(
                width: 5.0,
              ),
            ],
          ),
          floatingActionButton: cubit.currentIndex == 0
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        navigateTo(context, NewPostScreen());
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.post_add_outlined,
                          color: Colors.black),
                    ),
                  ),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeButtonNav(index);
            },
            items: cubit.bottomItems,
          ),
          body: cubit.screenss[cubit.currentIndex],
        );
      },
    );
  }
}
