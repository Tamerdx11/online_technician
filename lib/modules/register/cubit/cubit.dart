import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/modules/register/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class AppRegisterCubit extends Cubit<AppRegisterState> {
  AppRegisterCubit() : super(AppRegisterInitialState());

  static AppRegisterCubit get(context) => BlocProvider.of(context);

  /// ----------------------- select image Profile -----------------------------

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

  /// -------------------- upload profile image with profile registration -----------------

  String imageUrl = '';
  void uploadProfileImageWithRegister() {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${Uri.file(profileImage!.path.toString()).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        imageUrl = value.toString();
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageErrorState());
    });
  }

  ///--------------- register authentication ----------------

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String location,
    required String phone,
  }) {
    if (profileImage != null) {
      uploadProfileImageWithRegister();
    }

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
          userImage: imageUrl != ''
              ? imageUrl
              : 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669387743~exp=1669388343~hmac=2a61727dbf9e1a3deba0672ef43e642a69431e56544a4fb0fe6b950dccecb919',
          location: location,
          phone: phone,
          uId: value.user!.uid.toString());
      uId = value.user!.uid.toString();
    }).catchError((error) {
      emit(AppRegisterErrorState(error));
    });
  }

  ///---------------------- create user -----------------------

  void createUser({
    required String name,
    required String email,
    required String userImage,
    required String location,
    required String phone,
    required String uId,
  }) {
    FirebaseMessaging.instance.getToken().then((token) {

      UserModel model = UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        location: location,
        userImage: userImage,
        hasProfession: false,
        profession: 'user',
        token: token.toString(),
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
        CacheHelper.savaData(key: 'token', value: token.toString());
        emit(AppCreateUserSuccessState());
      }).catchError((error) {
        emit(AppCreateUserErrorState(error));
      });
    }).catchError((error){
      debugPrint(error.toString());
    });

  }

  bool isPassword = true;
  void showPassword() {
    isPassword = !isPassword;
    emit(AppRegisterPasswordState());
  }
}
