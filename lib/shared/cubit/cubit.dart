import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:online_technician/models/message.dart';
import 'package:online_technician/models/post.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/modules/feeds/feeds_screen.dart';
import 'package:online_technician/modules/new-post/new_post_screen.dart';
import 'package:online_technician/modules/notification/notification_screen.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/states.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  final storageRef = firebase_storage.FirebaseStorage.instance.ref();

  ///---------- get data of user who logged in ----------

  UserModel? model;

  void getUserData() {
    emit(AppGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      model = UserModel.fromJson(value.data());
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  ///---------- main layout navigation ----------

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    NotificationScreen(),
    NewPostScreen(),
  ];

  void changeButtonNav(int index) {
      currentIndex = index;
      emit(AppChangeButtonNavState());
  }

  // void changeButtonNav(int index) {
  //   if(index == 1) {
  //     getUsers();
  //   }
  //   if (index == 2) {
  //     emit(AppNewPostState());
  //   } else {
  //     currentIndex = index;
  //     emit(AppChangeButtonNavState());
  //   }
  // }

  /// ------------get imageProfile-------------

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

  /// ------------get background image-------------

  File? coverImage;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AppCoverImagePickedSuccessState());
    } else {
      emit(AppCoverImagePickedErrorState());
    }
  }

  /// ----------upload profile image----------

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
        'users/${Uri.file(profileImage!.path.toString()).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserdata( userImage: value);
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageErrorState());
    });
  }

  ///----------upload cover image----------

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserdata( coverImage: value);
      }).catchError((error) {
        emit(AppUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadCoverImageErrorState());
    });
  }

  ///----------  update user data ----------

  void updateUserdata({
    String? name,
    String? phone,
    String? email,
    String? location,
    String? profession,
    String? userImage,
    String? coverImage,
  }) {
    emit(AppUserUpdateLoadingState());
    UserModel newModel = UserModel(
      name: name?? model!.name,
      phone: phone?? model!.phone,
      email: email?? model!.email,
      location: location?? model?.location,
      profession: profession ?? model?.profession,
      userImage: userImage ?? model?.userImage,
      coverImage: coverImage ?? model?.coverImage,
      uId: uId,
      hasProfession: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(newModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(AppUserUpdateErrorState());
    });
  }

  ///---------- create post ----------

  File? postImage = null;

  void removePostImage() {
    postImage = null;
    emit(AppRemovePostImageState());
  }

  Future<void> getPostImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      emit(AppPostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
  }) {
    emit(AppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          text: text,
          dateTime: dateTime,
          postImages: [value],
        );
      }).catchError((error) {
        emit(AppCreatePostErrorState());
      });
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  void createPost({
    required String text,
    required String dateTime,
    List<String>? postImages,
  }) {
    emit(AppCreatePostLoadingState());
    PostModel newPostModel = PostModel(
      name: model!.name,
      userImage: model?.userImage,
      location: model?.location,
      uId: model?.uId.toString(),
      postText: text,
      dateTime: dateTime,
      postImages: postImages?? [],
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(newPostModel.toMap())
        .then((value) {
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      emit(AppUserUpdateErrorState());
    });
  }

  ///---------- get posts ----------

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference
            .collection('likes')
            .get()
            .then((value) {
          likes.add(value.docs.length);
          postId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(AppGetPostsSuccessState());
        })
            .catchError((error) {});
      });
      emit(AppGetPostsSuccessState());
    }).catchError((error) {
      emit(AppGetPostsErrorState(error.toString()));
    });
  }

  ///---------- like post ----------

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uId.toString())
        .set({
      'like': true,
    }).then((value) {
      emit(AppLikePostSuccessState());
    }).catchError((error) {
      emit(AppLikePostErrorState(error.toString()));
    });
  }

  ///---------- get all users ----------

  List<UserModel> users = [];

  void getUsers(){
    users = [];
    FirebaseFirestore.instance.collection('users')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if(element.data()['uId'] != model?.uId){
          users.add(UserModel.fromJson(element.data()));
        }
      }
      emit(AppGetAllUsersSuccessState());
    }).catchError((error) {
      emit(AppGetAllUsersErrorState(error.toString()));
    });
  }

  ///---------- send message ----------

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  })
  {
    MessageModel messageModel =MessageModel(
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
      senderId: model!.uId.toString(),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    })
        .catchError((error) {
      emit(AppSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(model!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    })
        .catchError((error) {
      emit(AppSendMessageErrorState());
    });
  }

///---------- get messages ----------

  List<MessageModel> messages =[];
  void getMessages({required String receiverId})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages =[];
      event.docs.forEach((element){
        messages.add(MessageModel.fromJson(element.data()));

      });
      emit(AppGetMessageSuccessState());
    });
  }

  ///---------- get search results ---------////////// getSearchData @ need to be customized ********

  List<dynamic> search = [];
  void getSearchData(String value)
  {
    emit(AppLoadingState());
    // DioHelper.getData(
    //   url: 'v2/everything',
    //   query: {
    //     'q':value,
    //     'apikey':'83c8070b8cc9458d862845f16c3b0130'
    //   },
    // ).then((value) {
    //   search = value.data['articles'];
    //   emit(AppGetSearchSuccessState());
    // }).catchError((error){
    //   emit(AppGetSearchErrorState());
    // });
  }

}
