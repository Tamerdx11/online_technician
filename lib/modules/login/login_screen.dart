import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/layout/home_layout.dart';
import 'package:online_technician/modules/login/cubit/cubit.dart';
import 'package:online_technician/modules/login/cubit/states.dart';
import 'package:online_technician/modules/register/register_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var code = "";
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppLoginCubit(),
      child: BlocConsumer<AppLoginCubit, AppLoginState>(
        listener: (context, state) {
          ///----- login error -----
          if (state is AppLoginErrorState) {
            showToast(text: state.error, state: ToastState.ERROR);
          }

          ///----- login success-----
          if (state is AppLoginSuccessState) {
            showToast(text: "نجح تسجيل الدخول", state: ToastState.SUCCESS);
            FirebaseFirestore.instance
                .collection('person')
                .doc(state.uid.toString())
                .get().then((value) {
              if(value.data()==null){
                navigateToAndFinish(context, RegisterScreen());
              }else{
                AppCubit.get(context).getUserData();
                CacheHelper.savaData(key: 'uId', value: state.uid.toString());
                navigateToAndFinish(context, AppLayout());
              }
            }).catchError((error){
              print('==========error=======');
            });
          }
        },
        builder: (context, state) {
          var cubit = AppLoginCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style:
                            Theme.of(context).textTheme.headline4?.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        'login now to connect with....',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormText(
                        isPassword: cubit.isPassword,
                        validate: (value) {
                          if (value.toString().isEmpty) {
                            return 'password does not match email!';
                          }
                          return null;
                        },
                        controller: passwordController,
                        label: 'Phone',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.showPassword();
                          },
                          icon: cubit.isPassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off_outlined),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! AppLoginLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            cubit.userLogin(
                              phone: passwordController.text,
                            );
                          },
                          text: 'Send code',
                          isUpperCase: true,
                          color: Colors.blue,
                        ),
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
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
                        label: 'code',
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultButton(
                          function: () {
                            cubit.checkCode(id: AppLoginCubit.verify.toString(), code: emailController.text);
                          },
                          text: 'verify'),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
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
