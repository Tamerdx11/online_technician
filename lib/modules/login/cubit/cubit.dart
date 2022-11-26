import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/login/cubit/states.dart';
import 'package:online_technician/shared/components/components.dart';

class AppLoginCubit extends Cubit<AppLoginState>{
  AppLoginCubit():super(AppLoginInitialState());
  static AppLoginCubit get(context)=>BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
}){
    emit(AppLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      emit(AppLoginSuccessState(value.user!.uid.toString()));
    }).catchError((error){
      emit(AppLoginErrorState(error));
    });
  }


  bool isPassword = true;
  void showPassword(){
    isPassword = !isPassword;
    emit(AppLoginPasswordState());
  }

}