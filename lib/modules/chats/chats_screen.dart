// ignore: import_of_legacy_library_into_null_safe
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';
import '../chat_details/chat_details_screen.dart';
import '../google_map2/GoogleMaps2.dart';
///E2

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:const Center(child: Text('Chats')),
            actions: [
              IconButton(onPressed: (){}, icon:const Icon(Icons.search_sharp,),)
            ],
          ),
          body: ConditionalBuilder(
            condition: AppCubit.get(context).users.isNotEmpty,
            builder: (context) => ListView.separated(
              physics:const  BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildChatItem(AppCubit.get(context).users[index], AppCubit.get(context).myuser[0],context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: AppCubit.get(context).users.length,

            ),
            fallback: (context) => const Center(child: CircularProgressIndicator()),
          ),

        );
      },
    );
  }

  Widget buildChatItem(UserModel model,UserModel mymodel, context) => Material(
    child: InkWell(
      onTap: () {
        navigateTo(
          context,
          ChatDetailsScreen(
            userModel: model,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                '${model.userImage}',
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Text(
              '${model.name}',
              style: const TextStyle(
                height: 1.4,
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            IconButton(
              onPressed: () {
                CacheHelper.savaData(key: 'latitude2', value: model.latitude);
                CacheHelper.savaData(key: 'longitude2', value: model.longitude);
                CacheHelper.savaData(key: 'name2', value: model.name);
                CacheHelper.savaData(key: 'latitude1', value: mymodel.latitude);
                CacheHelper.savaData(key: 'longitude1', value: mymodel.longitude);
                CacheHelper.savaData(key: 'name1', value: mymodel.name);
                navigateTo(context, GoogleMaps2());
                ///*****************
              },
              icon: const Icon(Icons.maps_ugc_sharp),
            ),
          ],
        ),
      ),
    ),
  );
}