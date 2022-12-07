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
    'Home',
    'Notification',
    'Your Sent Requests',
    'New Received Requests',
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
                  elevation: 20.0,
                  width: 230.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        curve: Curves.easeInOut,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
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
            backgroundColor: Colors.purple.withOpacity(0.65),
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
                ),
              const SizedBox(width: 3.0,),
              if (cubit.currentIndex == 0)
                IconButton(
                  onPressed: () {
                    navigateTo(context, const ChatsScreen());
                    AppCubit.get(context).getUsers();
                  },
                  icon: const Icon(Icons.mark_unread_chat_alt_rounded),
                ),
              const SizedBox(width: 5.0,),
            ],
          ),
          floatingActionButton: cubit.currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () {
                    navigateTo(context, NewPostScreen());
                  },
                  backgroundColor: Colors.blue.withOpacity(0.6),
                  child: const Icon(Icons.add_photo_alternate_outlined),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.redAccent.withOpacity(0.65),
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
