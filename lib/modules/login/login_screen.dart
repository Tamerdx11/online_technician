import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/layout/home_layout.dart';
import 'package:online_technician/modules/login/cubit/cubit.dart';
import 'package:online_technician/modules/login/cubit/states.dart';
import 'package:online_technician/modules/login/verify_code.dart';
import 'package:online_technician/modules/register/register_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var code = "";
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppLoginCubit(),
      child: BlocConsumer<AppLoginCubit, AppLoginState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var cubit = AppLoginCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'تسجيل الدخول',
                                style:
                                    Theme.of(context).textTheme.headline4?.copyWith(
                                          color: Colors.black,
                                        ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                             Text(
                                'سجل دخول الان لاستكشاف افضل الفنيين...',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                               textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormText(
                            validate: (value) {
                              if (value.toString().isEmpty) {
                                return 'يرجي ادخال رقم الهاتف';
                              }
                              else{
                                return null;
                              }
                            },
                            controller: passwordController,
                            label: 'الهاتف',
                            keyboardType: TextInputType.phone,
                            prefixIcon:  const Icon(Icons.phone_outlined,color:Colors.black),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                           defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()){
                                cubit.userLogin(
                                  phone: passwordController.text,
                                );
                                navigateTo(context, verifycode(phonenumber: passwordController.text,));
                                }

                              },
                              text: 'ارسال الكود الخاص بك',
                              isUpperCase: true,
                            ),
                        ],
                      ),
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
