import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

// ignore: must_be_immutable
class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context).model;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if(state is AppCreatePostLoadingState)
                const LinearProgressIndicator(),
              if(state is AppCreatePostLoadingState)
                const SizedBox(
                  height: 5.0,
                ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage('${cubit?.userImage}'),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Text(
                      '${cubit?.name}',
                      style:const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextFormField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "what is on your mind?...",
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              if(AppCubit.get(context).postImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 150.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            4.0
                        ),
                        image: DecorationImage(
                          image: FileImage(AppCubit.get(context).postImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AppCubit.get(context).removePostImage();
                      },
                      icon: CircleAvatar(
                        backgroundColor:
                        Colors.black.withOpacity(0.4),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              // const SizedBox(height: 100.0,),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        AppCubit.get(context).getPostImage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_photo_alternate_outlined),
                          SizedBox(
                            width: 0.5,
                          ),
                          Text("add images"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
