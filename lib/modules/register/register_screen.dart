import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/layout/home_layout.dart';
import 'package:online_technician/modules/register/cubit/cubit.dart';
import 'package:online_technician/modules/register/cubit/states.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';
import '../google_map/google_map.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppRegisterCubit(),
      child: BlocConsumer<AppRegisterCubit, AppRegisterState>(
        listener: (context, state) {
          if (state is AppCreateUserSuccessState) {
            AppCubit.get(context).getUserData();
            navigateToAndFinish(context, AppLayout());
          }
        },
        builder: (context, state) {
          var profileImage = AppRegisterCubit.get(context).profileImage;
          ImageProvider? image_profile;
          if (profileImage == null) {
            image_profile = const NetworkImage('https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669387743~exp=1669388343~hmac=2a61727dbf9e1a3deba0672ef43e642a69431e56544a4fb0fe6b950dccecb919');
          } else {
            image_profile = FileImage(profileImage);
          }

          return Scaffold(
            backgroundColor: HexColor('#ebebeb'),
            appBar: defaultAppBar(
              context: context,
              title: " بيانات التسجيل ",
              color: HexColor('#80b0c8'),
            ),
            body: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 63.0,
                                backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: image_profile,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  AppRegisterCubit.get(context).getProfileImage();
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
                          ),],
                        ),
                        const SizedBox(
                          height: 80.0,
                        ),
                        defaultFormText(
                          validate: (value) {
                            if (value.toString().isEmpty) {
                              return 'يرجي إدخال الأسم';
                            }
                            return null;
                          },
                          controller: usernameController,
                          label: 'الاسم',
                          keyboardType: TextInputType.text,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                          Row(
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
                                        "تحديد موقعي",
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
                              const SizedBox(width: 10.0,),
                              const Text(
                                "يرجي تحديد موقعك علي الخريطة ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                              const SizedBox(width: 5.0,),
                            ],
                          ),
                        const SizedBox(
                          height: 80.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! AppRegisterLoadingState,
                          builder: (context) => defaultButton(
                            color: HexColor('#78b7b7'),
                            function: () {
                              if (formKey.currentState!.validate()) {
                                AppRegisterCubit.get(context).userRegister(
                                  name: usernameController.text,
                                  phone: CacheHelper.getData(key: 'phoneNumber'),
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'التسجيل',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
