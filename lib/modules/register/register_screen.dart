import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/layout/home_layout.dart';
import 'package:online_technician/modules/register/cubit/cubit.dart';
import 'package:online_technician/modules/register/cubit/states.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';

import '../google_map/google_map.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppRegisterCubit(),
      child: BlocConsumer<AppRegisterCubit, AppRegisterState>(
        listener: (context, state) {
          if (state is AppCreateUserSuccessState) {
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
            appBar: defaultAppBar(
              context: context,
              title: "REGISTER",
              color: Colors.grey,
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          height: 20.0,
                        ),
                        defaultFormText(
                          validate: (value) {
                            if (value.toString().isEmpty) {
                              return 'name is too short!';
                            }
                            return null;
                          },
                          controller: usernameController,
                          onSubmitted: (value) {},
                          onchange: (value) {},
                          label: 'username',
                          keyboardType: TextInputType.text,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormText(
                          validate: (value) {
                            if (value.toString().isEmpty) {
                              return 'email is too short!';
                            }
                            return null;
                          },
                          controller: emailController,
                          onSubmitted: (value) {},
                          onchange: (value) {},
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormText(
                          isPassword: AppRegisterCubit.get(context).isPassword,
                          onchange: (value) {},
                          validate: (value) {
                            if (value.toString().isEmpty) {
                              return 'password very short!';
                            }
                            return null;
                          },
                          controller: passwordController,
                          onSubmitted: (value) {},
                          label: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              AppRegisterCubit.get(context).showPassword();
                            },
                            icon: AppRegisterCubit.get(context).isPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormText(
                          validate: (value) {
                            if (value.toString().isEmpty) {
                              return 'phone is too short!';
                            }
                            return null;
                          },
                          controller: phoneController,
                          onSubmitted: (value) {},
                          onchange: (value) {},
                          label: 'phone number',
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormText(
                          validate: (value) {
                            if (value.toString().isEmpty) {
                              return 'phone is too short!';
                            }
                            return null;
                          },
                          controller: locationController,
                          onSubmitted: (value) {},
                          onchange: (value) {},
                          label: 'your location',
                          keyboardType: TextInputType.text,
                          prefixIcon: const Icon(Icons.add_location_rounded),
                        ),
                          IconButton(
                            onPressed: () {
                              navigateTo(context, GoogleMaps());
                              ///*****************
                            },
                            icon: const Icon(Icons.maps_ugc_sharp),
                          ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! AppRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                AppRegisterCubit.get(context).uploadProfileImageWithRegister(
                                  location: locationController.text,
                                  name: usernameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'Register',
                            isUpperCase: true,
                            color: Colors.grey,
                            textColor: Colors.white,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
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
