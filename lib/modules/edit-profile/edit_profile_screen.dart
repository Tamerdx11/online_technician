import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController(); ///add controllers for all params in updateUserdata(**)

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AppCubit.get(context).model;
        var profileImage = AppCubit.get(context).profileImage;
        var coverImage = AppCubit.get(context).coverImage;
        nameController.text = userModel!.name.toString();
        phoneController.text = userModel.phone.toString();
        bioController.text = userModel.location.toString();

        ImageProvider image_profile;
        if (profileImage == null) {
          image_profile = NetworkImage('${userModel.userImage}');
        } else {
          image_profile = FileImage(profileImage);
        }

        ImageProvider image_cover;
        if (coverImage == null) {
          image_cover = NetworkImage('${userModel.coverImage}');
        } else {
          image_cover = FileImage(coverImage);
        }

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: "Edit Your Profile",
            actions: [
              TextButton(
                onPressed: () {
                  AppCubit.get(context).updateUserdata();/// edit parameters as needded
                },
                child: const Text(
                  "UPDATE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // if(state is AppUserUpdateLoadingState)
                  //   const LinearProgressIndicator(),
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  image: DecorationImage(
                                    image: image_cover,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  AppCubit.get(context).getCoverImage();
                                },
                                icon: CircleAvatar(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.4),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: image_profile,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                AppCubit.get(context).getProfileImage();
                              },
                              icon: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.4),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (AppCubit.get(context).profileImage != null ||
                      AppCubit.get(context).coverImage != null)
                    const SizedBox(
                      height: 15.0,
                    ),
                  if (AppCubit.get(context).profileImage != null ||
                      AppCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (AppCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    AppCubit.get(context).uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                  text: 'Upload Profile Image',
                                  color: Colors.lightBlueAccent,
                                  isUpperCase: false,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                if (state is AppUserUpdateLoadingState)
                                  const SizedBox(
                                    height: 0.3,
                                  ),
                                if (state is AppUserUpdateLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        if (AppCubit.get(context).profileImage != null &&
                            AppCubit.get(context).coverImage != null)
                          const SizedBox(
                            width: 10.0,
                          ),
                        if (AppCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    AppCubit.get(context).uploadCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                  text: 'Upload Cover Image',
                                  color: Colors.lightBlueAccent,
                                  isUpperCase: false,
                                ),
                                if (state is AppUserUpdateLoadingState)
                                  const SizedBox(
                                    height: 0.3,
                                  ),
                                if (state is AppUserUpdateLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  defaultFormText(
                    validate: (value) =>
                        value.isEmpty ? "name must not be empty" : null,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    onSubmitted: (value) {},
                    onchange: (value) {},
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    label: 'Name',
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  defaultFormText(
                    validate: (value) =>
                        value.isEmpty ? "phone number must not be empty" : null,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    onSubmitted: (value) {},
                    onchange: (value) {},
                    prefixIcon: const Icon(Icons.phonelink_ring),
                    label: 'Phone',
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  defaultFormText(
                    validate: (value) =>
                        value.isEmpty ? "bio must not be empty" : null,
                    controller: bioController,
                    keyboardType: TextInputType.name,
                    onSubmitted: (value) {},
                    onchange: (value) {},
                    prefixIcon: const Icon(Icons.info_outlined),
                    label: 'Bio',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
