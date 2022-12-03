import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var locationController = TextEditingController();
  var bioController = TextEditingController();
  var nationalIdController = TextEditingController();
  var professionController = TextEditingController();

  ///add controllers for all params in updateUserdata(**)

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        bool? hasProfession = AppCubit.get(context).hasProfession;

        var userModel = AppCubit.get(context).model;
        var profileImage = AppCubit.get(context).profileImage;
        var coverImage = AppCubit.get(context).coverImage;
        var idCardImage = AppCubit.get(context).idCardImage;

        nameController.text = userModel!.name.toString();
        phoneController.text = userModel.phone.toString();
        locationController.text = userModel.location.toString();
        if(CacheHelper.getData(key: 'hasProfession') == true)
        {
          bioController.text = userModel.bio;
          nationalIdController.text = userModel.nationalId;
          professionController.text = userModel.profession;
        }

        ImageProvider ib_card_image;
        if (idCardImage == null ) {
          ib_card_image = NetworkImage('${userModel.userImage}');
        } else
        {
          ib_card_image = FileImage(idCardImage);
        }

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
            color: Colors.redAccent.withOpacity(0.5),
            title: "Edit Your Profile",
            actions: [
              TextButton(
                onPressed: ()
                {
                  AppCubit.get(context).updateProfileDate(
                    context: context,
                    name: nameController.text,
                    phone: phoneController.text,
                    location: locationController.text,
                    profession: professionController.text,
                    bio: bioController.text,
                    nationalId: nationalIdController.text,
                  );
                },
                child: const Text(
                  "UPDATE",
                  style: TextStyle(
                    color: Colors.black,
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
            child: Column(
              children: [
                SizedBox(
                  height: 200,
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
                                  bottomRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
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
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 66.0,
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
                const SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: defaultFormText(
                    validate: (value) =>
                        value.isEmpty ? "name must not be empty" : null,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    onSubmitted: (value) {},
                    onchange: (value) {},
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    label: 'Name',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: defaultFormText(
                    validate: (value) =>
                        value.isEmpty ? "phone number must not be empty" : null,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    onSubmitted: (value) {},
                    onchange: (value) {},
                    prefixIcon: const Icon(Icons.phonelink_ring),
                    label: 'Phone',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: defaultFormText(
                    validate: (value) =>
                        value.isEmpty ? "locaion must not be empty" : null,
                    controller: locationController,
                    keyboardType: TextInputType.name,
                    onSubmitted: (value) {},
                    onchange: (value) {},
                    prefixIcon: const Icon(Icons.my_location_outlined),
                    label: 'location',
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CheckboxListTile(
                      title: const Text(
                        "do you seek to offer a service?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: hasProfession,
                      onChanged: (value) {
                        AppCubit.get(context).checkboxChange(value);
                      }),
                ),
                if (hasProfession)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: defaultFormText(
                      validate: (value) =>
                          value.isEmpty ? "bio must not be empty" : null,
                      controller: bioController,
                      keyboardType: TextInputType.name,
                      onSubmitted: (value) {},
                      onchange: (value) {},
                      prefixIcon: const Icon(Icons.info_outlined),
                      label: 'Bio',
                    ),
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                if (hasProfession)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: defaultFormText(
                      validate: (value) =>
                          value.isEmpty ? "ID must not be empty" : null,
                      controller: nationalIdController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {},
                      onchange: (value) {},
                      prefixIcon: const Icon(Icons.numbers),
                      label: 'national ID',
                    ),
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                if (hasProfession)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: defaultFormText(
                      validate: (value) =>
                      value.isEmpty ? "Profession must not be empty" : null,
                      controller: professionController,
                      keyboardType: TextInputType.text,
                      onSubmitted: (value) {},
                      onchange: (value) {},
                      prefixIcon: const Icon(Icons.settings_suggest_outlined),
                      label: 'Profession',
                    ),
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                if (hasProfession)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        const SizedBox(
                          width: 3.0,
                        ),
                        const Text(
                          'choose ID card photo ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 50.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  image: DecorationImage(
                                    image: ib_card_image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  AppCubit.get(context).getIdCardImage();
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
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 40.0,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
