import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/login/cubit/cubit.dart';
import 'package:online_technician/modules/login/cubit/states.dart';
import 'package:online_technician/modules/login/verify_code.dart';
import 'package:online_technician/shared/components/components.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var code = "";
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppLoginCubit(),
      child: BlocConsumer<AppLoginCubit, AppLoginState>(
        listener: (context, state) {},
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
                                'أستكشاف افضل الفنيين في كل المجالات',
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
                            controller: phoneController,
                            label: 'رقم الهاتف',
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
                                  phone: phoneController.text,);
                                navigateTo(context, verifyCodeScreen(phoneNumber: phoneController.text,));
                                }
                              },
                              text: 'تسجيل',
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
