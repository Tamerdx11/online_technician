import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/modules/login/cubit/cubit.dart';
import 'package:online_technician/shared/styles/colors.dart';
import 'package:pinput/pinput.dart';
import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/network/local/cache_helper.dart';
import '../register/register_screen.dart';
import 'cubit/states.dart';

class verifyCodeScreen extends StatelessWidget {

  final FocusNode _pintptofoucus = FocusNode();
  String? verificationCode;
  String phoneNumber;

  verifyCodeScreen({super.key,required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AppLoginCubit(),
      child: BlocConsumer<AppLoginCubit, AppLoginState>(
        listener: (context, state) {
          if (state is AppLoginErrorState) {
            showToast(text: state.error, state: ToastState.ERROR);
          }
          if (state is AppLoginSuccessState) {
            showToast(text: "تم تسجيل الدخول بنجاح", state: ToastState.SUCCESS);
            FirebaseFirestore.instance
                .collection('person')
                .doc(state.uid.toString())
                .get().then((value) {
              if (value.data() == null) {
                navigateToAndFinish(context, RegisterScreen());
              } else {
                AppCubit.get(context).getUserData();
                CacheHelper.savaData(key: 'uId', value: state.uid.toString());
                CacheHelper.savaData(key: 'hasProfession', value: value.data()!['hasProfession']);
                Timer(const Duration(seconds: 3), () {
                  showToast(text: 'مرحبا بعودتك', state: ToastState.SUCCESS);
                  navigateToAndFinish(context, AppLayout());
                });
              }
            }).catchError((error) {});
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: background_color,
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0,right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                  'يرجي أنتظار رمز التحقق',
                                  style: TextStyle(
                                      color:Colors.black,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                  ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0,right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  'تم إرسال رسالة مرفق بها الرمز علي الرقم $phoneNumber',
                                  style:const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0,),
                        Pinput(
                              defaultPinTheme: defaultPinTheme,
                              followingPinTheme: defaultPinTheme,
                              focusedPinTheme: defaultPinTheme,
                              submittedPinTheme: defaultPinTheme.copyWith(
                                decoration: defaultPinTheme.decoration!.copyWith(
                                  color: header_color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              focusNode: _pintptofoucus,
                              controller: AppLoginCubit.get(context).pintotpcontrol,
                              onCompleted:  (pin) {
                                AppLoginCubit.get(context).checkCode(
                                  id: AppLoginCubit.verify.toString(),
                                  code: AppLoginCubit.get(context).pintotpcontrol.text);
                              },
                          length: 6,
                          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
                        ),
                        const SizedBox(height: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: (){
                                    AppLoginCubit.get(context).userLogin(phone: phoneNumber);
                                  },
                                  child:const Text(
                                      "إعادة ارسال الرمز",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                const Text(' في حالة عدم استلام رمز التحقيق '),
                              ],
                            ),
                            const Text('يرجي الأنتظار 15 ثانية علي الأقل قبل إعادة الأرسال ', style: TextStyle(fontSize: 12.0),),
                          ],
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