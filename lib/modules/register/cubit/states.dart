abstract class AppRegisterState{}

class AppRegisterInitialState extends AppRegisterState{}

class AppRegisterLoadingState extends AppRegisterState{}

class AppRegisterSuccessState extends AppRegisterState{}

class AppRegisterErrorState extends AppRegisterState{
  final String error;
  AppRegisterErrorState(this.error);
}

class AppCreateUserSuccessState extends AppRegisterState{}

class AppCreateUserErrorState extends AppRegisterState{
  final String error;
  AppCreateUserErrorState(this.error);
}

class AppRegisterPasswordState extends AppRegisterState{}

class AppProfileImagePickedSuccessState extends AppRegisterState{}

class AppProfileImagePickedErrorState extends AppRegisterState{}

class AppUserUpdateLoadingState extends AppRegisterState{}

class AppUploadProfileImageSuccessState extends AppRegisterState{}

class AppUploadProfileImageErrorState extends AppRegisterState{}