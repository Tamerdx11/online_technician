import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/login/cubit/cubit.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/network/local/cache_helper.dart';
import '../register/register_screen.dart';
import 'cubit/states.dart';
import 'login_screen.dart';

class verifycode extends StatelessWidget {

  final TextEditingController _pintotpcontrol = TextEditingController();
  final FocusNode _pintptofoucus = FocusNode();
  String? varificationcode;
  String phonenumber;
  verifycode({required this.phonenumber});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AppLoginCubit(),
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
              if (value.data() == null) {
                navigateToAndFinish(context, RegisterScreen());
              } else {
                AppCubit.get(context).getUserData();
                CacheHelper.savaData(key: 'uId', value: state.uid.toString());
                navigateToAndFinish(context, AppLayout());
              }
            }).catchError((error) {
              print('==========error=======');
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5,right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('يرجي ادخال كود التحقق',style: TextStyle(color:Colors.black,fontSize: 25,fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20,right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('تم ارسال رسالة مرفق بها الكود',style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        PinPut(
                              fieldsCount: 6,
                              textStyle: const TextStyle(
                              color: Colors.white, fontSize: 25,),
                              eachFieldHeight: 30,
                              eachFieldWidth: 30,
                              eachFieldPadding: EdgeInsets.all(5),
                              focusNode: _pintptofoucus,
                              controller: _pintotpcontrol,
                              cursorColor: Colors.white,
                              cursorHeight: 15,
                              submittedFieldDecoration: PinOtpDeco1,
                              selectedFieldDecoration: PinOtpDeco,
                              followingFieldDecoration: PinOtpDeco,
                              onSubmit: (pin) {
                              AppLoginCubit.get(context).checkCode(
                                  id: AppLoginCubit.verify.toString(),
                                  code: _pintotpcontrol.text);
                            }
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: defaultButton(
                            function: () {
                              navigateTo(context, LoginScreen());
                            },
                            text: 'ارسال الكود',
                            isUpperCase: true,
                            width: 125,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: defaultButton(
                            function: () {
                              print("**********************************");
                              print(phonenumber);
                              AppLoginCubit.get(context).userLogin(phone: phonenumber);
                            },
                            text: 'اعادة ارسال',
                            isUpperCase: true,
                            width: 125,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              )
          );
        },
      ),
    );
  }
}