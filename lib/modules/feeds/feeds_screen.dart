// ignore: import_of_legacy_library_into_null_safe
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return ConditionalBuilder(

          condition: cubit.posts.length > 0 && cubit.users != 'null',
          builder: (context)=>SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children:
              [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 20,
                  margin: const EdgeInsets.all(9),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      const Image(
                        width: double.infinity,
                        image: NetworkImage('https://img.freepik.com/free-photo/closeup-portrait-cheerful-lovely-feminine-blond-girl-white-dress-taking-selfie-mobile-phone-make-kawaii-peace-sign-while-take-photo-capturing-spring-moment-pink-background_1258-100822.jpg?w=996&t=st=1667153210~exp=1667153810~hmac=63a5251d058785fe732d8df2473a3a12a4b7b2d7720ffa6b0cc654b06cd1564e'),
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'communicate with friends',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index)=>buildPostItem(cubit.posts[index],context,index),
                  separatorBuilder: (context,index)=>const SizedBox(
                    height: 10,
                  ),
                  itemCount:cubit.posts.length,
                ),
                const SizedBox(
                  height: 8,
                ),

              ],
            ),
          ),
          fallback: (context)=>const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

