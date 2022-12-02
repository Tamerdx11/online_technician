import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/chats/chats_screen.dart';
import 'package:online_technician/modules/profile/profile_screen.dart';
import 'package:online_technician/modules/search/search_screen.dart';
import 'package:online_technician/modules/settings/settings_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

import '../modules/google_map/google_map.dart';

// ignore: must_be_immutable
class AppLayout extends StatelessWidget {
  AppLayout({Key? key}) : super(key: key);

  List<String> titles = [
    'Home',
    'Notification',
    'New Post',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppNewPostState) {
          navigateTo(context, AppLayout());
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          drawer: cubit.currentIndex == 0
              ? Drawer(
                  backgroundColor: Colors.white,
                  elevation: 20.0,
                  width: 230.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        curve: Curves.easeInOut,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          // borderRadius: BorderRadius.only(
                          //   topRight: Radius.circular(30.0),
                          //   topLeft: Radius.circular(30.0),
                          // ),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 48.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 45.0,
                                backgroundImage:
                                    NetworkImage('${cubit.model?.userImage}'),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
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
                        title: const Text(
                          'Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(context, ProfileScreen());
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(context, SettingsScreen());
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
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
            backgroundColor: Colors.grey,
            title: cubit.currentIndex != 0
                ? Text(
                    titles[cubit.currentIndex],
                    style: const TextStyle(color: Colors.black),
                  )
                : null,
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
                    navigateTo(context, SearchScreen());
                  },
                  icon: const Icon(Icons.search_rounded),
                )
              else
                const SizedBox(),
              if (cubit.currentIndex == 0)
                IconButton(
                  onPressed: () {
                    navigateTo(context, ChatsScreen());
                    ///*****************
                    AppCubit.get(context).getUsers();
                  },
                  icon: const Icon(Icons.mark_unread_chat_alt_rounded),
                )
              else
                const SizedBox(),

            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeButtonNav(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notification_add_rounded),
                  label: "notification"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box), label: "add post"),
            ],
          ),
          floatingActionButton: cubit.currentIndex == 4
              ? FloatingActionButton(
                  onPressed: () {
                    navigateTo(context, Container());
                  },
                  backgroundColor: Colors.teal.withOpacity(0.6),
                  child: const Icon(Icons.edit_note_sharp),
                )
              : Row(),
        );
      },
    );
  }
}
