import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/login/cubit/states.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';

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
            showToast(text: "تم ارسال الكود, يرجي فحص البريد الخاص بك", state: ToastState.SUCCESS);
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
          timeout: const Duration(seconds: 5),
        )
        .then((value) {})
        .catchError((error) {
          emit(AppLoginErrorState(error.toString()));
    });
  }

  void checkCode({
    required String id,
  required String code,
  })
  {
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
        showToast(text: "الكود غير صحيح", state: ToastState.ERROR);
      });
    } catch (e) {
      showToast(text: "حدث خطأ في التسجيل يرجي المحاولة لاحقا", state: ToastState.ERROR);
    }
  }

  bool isPassword = true;
  void showPassword() {
    isPassword = !isPassword;
    emit(AppLoginPasswordState());
  }
}
