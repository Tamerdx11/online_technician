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
  var locationController = TextEditingController();
  var bioController = TextEditingController();
  var nationalIdController = TextEditingController();
  List<String> list =const [
    'نقاش',
    'كهربائي',
    'نجار',
    'صيانة حمامات السباحة',
    'سباك',
    'بنّاء',
    'ميكانيكي',
    'مكافحة حشرات',
    'صيانة اجهزة منزلية',
    'صيانة دش',
    'اعمال زجاج',
    'اعمال رخام',
    'عامل بناء',
    'اعمال ارضيات',
    'حداد',
    'محار',
    'جزار'
  ];
  String? dropdownValue = 'أختر الحرفة الخاصة بك';
  int x = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is change) {
          dropdownValue = AppCubit.get(context).profession!;
        }
      },
      builder: (context, state) {

        bool hasProfession = AppCubit.get(context).hasProfession;
        var userModel = AppCubit.get(context).model;
        var profileImage = AppCubit.get(context).profileImage;
        var coverImage = AppCubit.get(context).coverImage;
        var idCardImage = AppCubit.get(context).idCardImage;
        nameController.text = userModel!.name.toString();
        locationController.text = userModel.location.toString();
        if (AppCubit.get(context).model.hasProfession && x != 1) {
          bioController.text = userModel.bio ?? '';
          nationalIdController.text = userModel.nationalId ?? '';
          dropdownValue = userModel.profession ?? '';
          x++;
        }

        ImageProvider ib_card_image;
        if (idCardImage == null) {
          ib_card_image = NetworkImage('${userModel.userImage}');
        } else {
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
            color: Colors.black26,
            title: "تعديل الحساب",
            textColor: Colors.black54,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {
                    AppCubit.get(context).updateProfileDate(
                      context: context,
                      name: nameController.text,
                      location: locationController.text,
                      bio: bioController.text,
                      nationalId: nationalIdController.text,
                      profession: dropdownValue,
                    );
                  },
                  child: const Text(
                    "حفظ التعديلات",
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
            ],
          ),
          body: Container(
            color: Colors.white24,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 205,
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
                                  borderRadius:
                                      const BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft:Radius.circular(30) ),
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
                          value.isEmpty ? "يرجي كتابة الاسم" : null,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      suffixIcon: const Icon(Icons.drive_file_rename_outline),
                      label: 'الاسم',
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: defaultFormText(
                      validate: (value) =>
                          value.isEmpty ? "يرجي كتابة الموقع" : null,
                      controller: locationController,
                      keyboardType: TextInputType.name,
                      suffixIcon: const Icon(Icons.location_on),
                      label: 'الموقع',
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CheckboxListTile(
                      enableFeedback: true,
                      activeColor: Colors.black,
                      value: hasProfession,
                      onChanged: (value) {
                        AppCubit.get(context).checkboxChange(value);
                      },
                      title: const Text("هل تريد تقديم خدمة؟",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  if (hasProfession == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: defaultFormText(
                        validate: (value) =>
                            value.isEmpty ? "يرجي كتابة نبذة عنك" : null,
                        controller: bioController,
                        keyboardType: TextInputType.name,
                        suffixIcon: const Icon(Icons.info_outlined),
                        label: 'نبذة عنك..',
                      ),
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (hasProfession == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: defaultFormText(
                        validate: (value) =>
                            value.isEmpty ? "يرجي كتابة الرقم القومي" : null,
                        controller: nationalIdController,
                        keyboardType: TextInputType.number,
                        suffixIcon: const Icon(Icons.add_card_sharp),
                        label: 'الرقم القومي',
                      ),
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (hasProfession == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              enableFeedback: true,
                              value: dropdownValue,
                              iconSize: 24,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:const BorderSide(color: Colors.grey),
                                ),
                              ),
                              icon: const Icon(
                                Icons.work_outline,
                                color: Colors.grey,
                              ),
                              elevation: 16,
                              style: const TextStyle(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12.0),
                              onChanged: (value) {
                                AppCubit.get(context).changeValue(value!);
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                    textDirection: TextDirection.rtl,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (hasProfession == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 55,
                            ),
                            child: Align(
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
                          ),
                          const Spacer(),
                          const Text(
                            'تحميل صورة البطاقة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(
                            width: 3.0,
                          ),
                          const Icon(
                            Icons.info_outline,
                            color: Colors.red,
                            size: 20.0,
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
          ),
        );
      },
    );
  }
}
