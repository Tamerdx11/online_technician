import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/modules/register/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:online_technician/shared/network/local/cache_helper.dart';

class AppRegisterCubit extends Cubit<AppRegisterState> {
  AppRegisterCubit() : super(AppRegisterInitialState());

  static AppRegisterCubit get(context) => BlocProvider.of(context);

  /// ------------select image Profile-------------

  final picker = ImagePicker();
  File? profileImage;
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path.toString());
      emit(AppProfileImagePickedSuccessState());
    } else {
      emit(AppProfileImagePickedErrorState());
    }
  }

  /// ---------- upload profile image with profile registration ----------

  void uploadProfileImageWithRegister({
    required String name,
    required String email,
    required String password,
    required String location,
    required String phone,
  }) {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${Uri.file(profileImage!.path.toString()).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        userRegister(
          name: name,
          location: location,
          password: password,
          phone: phone,
          userImage: value,
          email: email,
        );
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageErrorState());
    });
  }

  ///---------- register authentication ----------

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String userImage,
    required String location,
    required String phone,
  }) {
    emit(AppRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
          name: name,
          email: email,
          userImage: userImage,
          location: location,
          phone: phone,
          uId: value.user!.uid.toString());
    }).catchError((error) {
      emit(AppRegisterErrorState(error));
    });
  }

  ///---------- create user ----------

  void createUser({
    required String name,
    required String email,
    required String userImage,
    required String location,
    required String phone,
    required String uId,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      location: location,
      userImage: userImage,
      hasProfession: false,
      token: token.toString(),
      latitude:latitude.toString(),
      longitude:longitude.toString(),
      profession: 'user',
      coverImage:
          'https://img.freepik.com/premium-photo/tool-working-with-equipment_231794-3282.jpg?w=740',
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      CacheHelper.savaData(key: 'uId', value: uId.toString());
      CacheHelper.savaData(key: 'hasProfession', value: false);
      emit(AppCreateUserSuccessState());
    }).catchError((error) {
      emit(AppCreateUserErrorState(error));
    });
  }

  bool isPassword = true;
  void showPassword() {
    isPassword = !isPassword;
    emit(AppRegisterPasswordState());
  }
}
