import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:online_technician/models/message.dart';
import 'package:online_technician/models/post.dart';
import 'package:online_technician/models/technician.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/modules/feeds/feeds_screen.dart';
import 'package:online_technician/modules/new-post/new_post_screen.dart';
import 'package:online_technician/modules/notification/notification_screen.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  final storageRef = firebase_storage.FirebaseStorage.instance.ref();

  ///---------- get user or technican data ----------

  var model;

  void getUserData() {
    if (CacheHelper.getData(key: 'hasProfession') == true) {
      emit(AppGetUserLoadingState());
      FirebaseFirestore.instance
          .collection('technicians')
          .doc(uId)
          .get()
          .then((value)  {
        model = TechnicianModel.fromJson(value.data());
        CacheHelper.savaData(key: 'name1', value: model.name);
        emit(AppGetUserSuccessState());
      }).catchError((error) {
        emit(AppGetUserErrorState(error.toString()));
        print('**************************************************************////////////////////////////////');
        print(error.toString());
      });
    } else {
      emit(AppGetUserLoadingState());
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) {
        model = UserModel.fromJson(value.data());
        emit(AppGetUserSuccessState());
      }).catchError((error) {
        emit(AppGetUserErrorState(error.toString()));
      });
    }
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

  ///---------- create post ----------

  final picker = ImagePicker();
  File? postImage =null ;

  void removePostImage() {
    postImage=null;
    emit(AppRemovePostImageState());
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage=File(pickedFile.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      emit(AppPostImagePickedErrorState());
    }
  }
  Future<void> getPostImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      postImage=File(pickedFile.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      emit(AppPostImagePickedErrorState());
    }
  }
  List<String>? postsImages;
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
          postImages:value,
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
    String? postImages,
  }) {
    emit(AppCreatePostLoadingState());
    PostModel newPostModel = PostModel(
      name: model!.name,
      userImage: model?.userImage,
      location: model?.location,
      uId: model?.uId.toString(),
      postText: text,
      dateTime: dateTime,
      postImages: postImages ?? '',
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

  ///---------- get posts & likes ----------

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(AppGetPostsSuccessState());
        }).catchError((error) {});
      });
      emit(AppGetPostsSuccessState());
    }).catchError((error) {
      emit(AppGetPostsErrorState(error.toString()));
    });
  }

  ///---------- add like post ----------

  bool isLove = true;
  void showLove(){
    isLove = !isLove;
  }
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
  void unlikePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uId.toString()).delete().then((value) {
      emit(AppLikePostSuccessState());
    }).catchError((error) {
      emit(AppLikePostErrorState(error.toString()));
    });
  }

  ///---------- get all users ----------
  List<UserModel> users = [];

  void getUsers() {
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != model?.uId) {
          users.add(UserModel.fromJson(element.data()));
        }
      }
      emit(AppGetAllUsersSuccessState());
    }).catchError((error) {
      emit(AppGetAllUsersErrorState(error.toString()));
      print('errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrror');
      print(error.toString());
    });
  }





  ///---------- send message ----------

  void sendMessage({
    required String? receiverId,
    required String? dateTime,
    required String? text,
  }) {
    MessageModel messageModel = MessageModel(
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
    }).catchError((error) {
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
    }).catchError((error) {
      emit(AppSendMessageErrorState());
    });
  }

  ///---------- get all messages ----------

  ///E2
  List<MessageModel> messages = [];
  void getMessages({required String? receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(AppGetMessageSuccessState());
    });
  }

  ///---------- get search results ---------////////// ******************--- search ---

  List<dynamic> search = [];
  void getSearchData(String value) {
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

  ///------------ has profession change ---------------

  bool hasProfession = CacheHelper.getData(key: 'hasProfession');

  void checkboxChange(value) {
    hasProfession = value;
    emit(AppChangeCheckboxState());
  }

  /// ------------ pick id_card_image from gallery ----------

  File? idCardImage = null;
  Future<void> getIdCardImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      idCardImage = File(pickedFile.path.toString());
      emit(AppIdCardImagePickedSuccessState());
    } else {
      emit(AppIdCardImagePickedErrorState());
    }
  }

  /// ------------pick imageProfile-------------

  File? profileImage = null;

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path.toString());
      emit(AppProfileImagePickedSuccessState());
    } else {
      emit(AppProfileImagePickedErrorState());
    }
  }

  /// ------------pick background image-------------

  File? coverImage = null;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AppCoverImagePickedSuccessState());
    } else {
      emit(AppCoverImagePickedErrorState());
    }
  }

  /// ---------- upload id card image ----------/// upload images /////////////////

  String? uploadedIdCardImage;
  void uploadIdCardImage() {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
        'users/${Uri.file(idCardImage!.path.toString()).pathSegments.last}')
        .putFile(idCardImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadedIdCardImage = value;
      }).catchError((error) {
        emit(AppUploadIdCardImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadIdCardImageErrorState());
    });
  }

  /// ----------upload profile image----------

  String? uploadedProfileImage;
  void uploadProfileImage() {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
        'users/${Uri.file(profileImage!.path.toString()).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadedProfileImage = value;
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageErrorState());
    });
  }

  ///----------upload cover image----------

  String? uploadedCoverImage;
  void uploadCoverImage() {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadedCoverImage = value;
      }).catchError((error) {
        emit(AppUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadCoverImageErrorState());
    });
  }

  ///----------  update profile data ----------//

  void updateProfileDate({
    String? name,
    String? phone,
    String? location,
    String? profession,
    String? bio,
    String? nationalId,
    required BuildContext context,
  }) {
    if (profileImage != null) {
      uploadProfileImage();
    }
    if (coverImage != null) {
      uploadCoverImage();
    }
    if (idCardImage != null)
    {
      uploadIdCardImage();
    }
    if (CacheHelper.getData(key: 'hasProfession') == true && hasProfession == true)
    {
      emit(AppTechnicianUpdateLoadingState());
      TechnicianModel newModel = TechnicianModel(
        name: name,
        uId: model!.uId,
        phone: phone,
        email: model!.email,
        bio: bio,
        nationalId: nationalId,
        idCardPhoto: uploadedIdCardImage,
        location: location,
        profession: profession,
        userImage: uploadedProfileImage,
        coverImage: uploadedProfileImage,
        hasProfession: true,
        latitude: model.latitude,
        longitude: model.longitude,
      );
      FirebaseFirestore.instance
          .collection('technicians')
          .doc(uId)
          .update(newModel.toMap())
          .then((value) {
        getUserData();
        Navigator.pop(context);
      }).catchError((error) {
        emit(AppTechnicianUpdateErrorState());
      });
    }
    else if (CacheHelper.getData(key: 'hasProfession') == false && hasProfession == true)
    {
      emit(AppTechnicianUpdateLoadingState());
      TechnicianModel newModel = TechnicianModel(
        name: name,
        uId: model!.uId,
        phone: phone,
        email: model!.email,
        bio: bio,
        nationalId: nationalId,
        idCardPhoto: uploadedIdCardImage,
        location: location,
        profession: profession,
        userImage: uploadedProfileImage ?? model?.userImage,
        coverImage: uploadedProfileImage ?? model?.coverImage,
        hasProfession: true,
        latitude: model.latitude,
        longitude: model.longitude,
      );
      FirebaseFirestore.instance
          .collection('technicians')
          .doc(uId)
          .set(newModel.toMap())
          .then((value) {
        CacheHelper.setData(key: 'hasProfession', value: true);
        getUserData();
        Navigator.pop(context);
      }).catchError((error) {
        emit(AppTechnicianUpdateErrorState());
      });
    }
    else if (CacheHelper.getData(key: 'hasProfession') == false && hasProfession == false)
    {
      emit(AppUserUpdateLoadingState());
      UserModel newModel = UserModel(
        name: name,
        phone: phone,
        email: model!.email,
        location: location,
        profession: 'user',
        userImage: uploadedProfileImage!.isEmpty
            ? model?.userImage
            : uploadedProfileImage,
        coverImage: uploadedCoverImage!.isEmpty
            ? model?.coverImage
            : uploadedCoverImage,
        uId: uId,
        hasProfession: false,
        latitude: model.latitude,
        longitude: model.longitude,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update(newModel.toMap())
          .then((value) {
        getUserData();
        Navigator.pop(context);
      }).catchError((error) {
        emit(AppUserUpdateErrorState());
      });
    }
    else if (CacheHelper.getData(key: 'hasProfession') == true && hasProfession == false)
    {
      emit(AppUserUpdateLoadingState());
      UserModel newModel = UserModel(
        name: name,
        phone: phone,
        email: model!.email,
        location: location,
        profession: 'user',
        userImage: uploadedProfileImage!.isEmpty
            ? model?.userImage
            : uploadedProfileImage,
        coverImage: uploadedCoverImage!.isEmpty
            ? model?.coverImage
            : uploadedCoverImage,
        uId: uId,
        hasProfession: false,
        latitude: model.latitude,
        longitude: model.longitude,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update(newModel.toMap())
          .then((value) {
        CacheHelper.setData(key: 'hasProfession', value: false);
        getUserData();
        Navigator.pop(context);
      }).catchError((error) {
        emit(AppUserUpdateErrorState());
      });
    }
  }
}
