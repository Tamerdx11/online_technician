import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AppCubit.get(context).model;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            color: Colors.grey,
            title: '${userModel!.name}',
            textColor: Colors.black,
            actions: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 245.0,
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
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage('${userModel.coverImage}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: CircleAvatar(
                              radius: 66.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage:
                                    NetworkImage('${userModel.userImage}'),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 30.0),
                            height: 125.0,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${userModel.name}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    children: [
                      userModel.hasProfession?const SizedBox(width: 10.0,):const SizedBox(width: 60.0,),
                      Expanded(
                        child: Text(
                          '${userModel.profession}',
                          style: userModel.hasProfession? const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.black,
                          ):const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      userModel.hasProfession
                          ? const Text(
                        'Rated: 15.0*',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.orange,
                        ),
                      )
                          : const SizedBox(),
                      userModel.hasProfession?const SizedBox(width: 20.0,):const SizedBox(width: 10.0,),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              '${userModel.location}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            const Icon(
                              Icons.my_location,
                              color: Colors.grey,
                              size: 35.0,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.wechat_sharp,
                          color: Colors.grey,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 1.0,
                    color: Colors.grey,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
