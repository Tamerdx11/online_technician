import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/google_map/google_map.dart';
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
  String? dropdownValue = 'نقاش';
  int x = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is change) {
          dropdownValue = AppCubit.get(context).profession!;
        }
        // ignore: unrelated_type_equality_checks
        if(state is AppTechnicianUpdateSuccessState){
          Timer(const Duration(seconds: 2), () {
            showToast(text: 'تم تحديث بياناتك بنجاح', state: ToastState.SUCCESS);
            Navigator.pop(context);
          });
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
          backgroundColor: HexColor('#ebebeb'),
          appBar: AppBar(
            backgroundColor: HexColor('#1d2021'),
            title:const Center(
              child: Text(
                'تعديل الحساب',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoNaskhArabic',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            leading: IconButton(
                onPressed: (){
                  AppCubit.get(context).checkboxChange(AppCubit.get(context).model.hasProfession);
                  Timer(const Duration(seconds: 1),(){
                    Navigator.pop(context);
                  });
                },
                icon:const Icon(Icons.arrow_back,color: Colors.white,),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
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
                  child: Text(
                    "حفظ التعديلات",
                    style: TextStyle(
                      color: HexColor('#A5E1AD'),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if(state is AppTechnicianUpdateLoadingState)
                    const LinearProgressIndicator(color: Colors.greenAccent),
                  const SizedBox(height: 25.0,),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image_profile,
                              fit: BoxFit.fill,
                            ),
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(12.0)
                            )
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          AppCubit.get(context).getProfileImage();
                        },
                        icon: CircleAvatar(
                          radius: 24.0,
                          backgroundColor:
                              Colors.black.withOpacity(0.5),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 23.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
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
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            navigateTo(context,const GoogleMaps());
                          },
                          child: Container(
                            padding:const EdgeInsets.symmetric(vertical: 3.0,horizontal: 6.0),
                            decoration: BoxDecoration(
                              color: HexColor('#dedded'),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(
                                30.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.my_location_rounded,color: HexColor('#59c9b0'),),
                                const SizedBox(width: 2.0,),
                                Text(
                                  "تغيير موقعي",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: HexColor('#59c9b0'),
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20.0,),
                        Text(
                          locationController.text,
                          style:const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CheckboxListTile(
                      activeColor: HexColor('#0A81AB'),
                      controlAffinity: ListTileControlAffinity.leading,
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
                          const SizedBox(width: 5.0,),
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
