import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/login/cubit/states.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class AppLoginCubit extends Cubit<AppLoginState> {
  AppLoginCubit() : super(AppLoginInitialState());
  static AppLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AppLoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(AppLoginSuccessState(value.user!.uid.toString()));
      uId = value.user!.uid.toString();
      CacheHelper.savaData(key: 'uId', value: uId);
    }).catchError((error) {
      emit(AppLoginErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  void showPassword() {
    isPassword = !isPassword;
    emit(AppLoginPasswordState());
  }
}
