abstract class AppLoginState{}

class AppLoginInitialState extends AppLoginState{}

class AppLoginLoadingState extends AppLoginState{}

class AppLoginSuccessState extends AppLoginState{
  final String uid;
  AppLoginSuccessState(this.uid);
}

class AppLoginErrorState extends AppLoginState{
  final String error;
  AppLoginErrorState(this.error);
}

class AppLoginPasswordState extends AppLoginState{}