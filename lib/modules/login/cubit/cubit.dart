import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/layout/home_layout.dart';
import 'package:online_technician/modules/login/cubit/states.dart';
import 'package:online_technician/modules/register/register_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class AppLoginCubit extends Cubit<AppLoginState> {
  AppLoginCubit() : super(AppLoginInitialState());
  static AppLoginCubit get(context) => BlocProvider.of(context);
  static String verify="";
  final FirebaseAuth auth = FirebaseAuth.instance;

  void userLogin({
    required String phone,
  }) {
    emit(AppLoginLoadingState());
    FirebaseAuth.instance
        .verifyPhoneNumber(
          phoneNumber: '+2$phone',
          verificationCompleted: (PhoneAuthCredential credential) {
            showToast(text: "تم ارسال الكود", state: ToastState.SUCCESS);
          },
          verificationFailed: (FirebaseAuthException e) {
            emit(AppLoginErrorState(e.toString()));
          },
          codeSent: (String verificationId, int? resendToken) {
            verify = verificationId;
            },
          codeAutoRetrievalTimeout: (String verificationId) {
            verify = verificationId;
            },
          timeout: Duration(seconds: 3),
        )
        .then((value) {})
        .catchError((error) {
          emit(AppLoginErrorState(error.toString()));
    });
  }

  void checkCode({
    required String id,
  required String code}){
    try {
      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
          verificationId:id,
          smsCode: code);
      auth.signInWithCredential(credential).then((value) {
        uId = value.user!.uid.toString();
        emit(AppLoginSuccessState(value.user!.uid.toString()));
      })
          .catchError((error) {
        print('-------------------------------login error--------------------------');
        print(error.toString());
      });
    } catch (e) {
      print('-------------------------------login error with e--------------------------');
      print(e.toString());
    }
  }

  bool isPassword = true;
  void showPassword() {
    isPassword = !isPassword;
    emit(AppLoginPasswordState());
  }
}
