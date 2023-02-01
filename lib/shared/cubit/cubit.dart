import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:online_technician/models/message.dart';
import 'package:online_technician/models/post.dart';
import 'package:online_technician/models/technician.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/modules/chat_details/chat_details_screen.dart';
import 'package:online_technician/modules/feeds/feeds_screen.dart';
import 'package:online_technician/modules/sent_requests/sent_requests_screen.dart';
import 'package:online_technician/modules/received_requests/received_requests_screen.dart';
import 'package:online_technician/modules/notification/notification_screen.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';
import 'package:online_technician/shared/network/remote/dio_helper.dart';

import '../components/components.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  final storageRef = firebase_storage.FirebaseStorage.instance.ref();

  ///---------- get person data ----------

  var model;
  void getUserData() {
    FirebaseFirestore.instance
        .collection('person')
        .doc(uId)
        .get().then((value) {
        if(value.data()!['hasProfession'])
        {
          CacheHelper.savaData(key: 'hasProfession', value: true);
          model = TechnicianModel.fromJson(value.data());
          emit(AppGetUserSuccessState());
        }
        else {
          CacheHelper.savaData(key: 'hasProfession', value: false);
          model = UserModel.fromJson(value.data());
          emit(AppGetUserSuccessState());
        }
      FirebaseMessaging.instance.getToken().then((token) {
        if (model.token.toString() != token.toString()) {
          FirebaseFirestore.instance
              .collection('person')
              .doc(model.uId.toString())
              .update({'token': token.toString()})
              .then((value) {})
              .catchError((error) {});
        }
      });
    }).catchError((error){
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  ///-----------get data for chat person----------

  void goToChatDetails(String id, BuildContext context){
    FirebaseFirestore.instance
        .collection('person')
        .doc(id.toString())
        .get().then((value){
          navigateTo(context, ChatDetailsScreen(
            userModel: UserModel.fromJson(value.data()),),);
    }).catchError((error){
      print(error.toString());
    });
  }

  ///---------- main layout navigation ----------

  int currentIndex = 0;
  List<Widget> screenss = [
    FeedsScreen(),
    NotificationScreen(),
    SentRequestsScreen(),
    ReceivedRequestsScreen(),
  ];
  List<BottomNavigationBarItem> bottomItems = const[
    BottomNavigationBarItem(
      icon: Icon(Icons.home_filled),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notification_add_rounded),
      label: "notification",),
    BottomNavigationBarItem(
      icon: Icon(Icons.hail),
      label: "Sent",),
    BottomNavigationBarItem(
      icon: Icon(Icons.handyman_sharp),
      label: "Received",),
  ];

  void changeButtonNav(int index) {
    currentIndex = index;
    emit(AppChangeButtonNavState());
  }

  var curr_index = 0;
  void changeCarousel(var index){

    curr_index = index;
     emit(AppChangeCarouselDotState());
  }

  ///---------- create post ----------

  final picker = ImagePicker();
  List<File> postImageFile =[];

  void removePostImage({required int index}) {
    postImageFile.removeAt(index);
    emit(AppRemovePostImageState());
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImageFile.add(File(pickedFile.path));
      emit(AppPostImagePickedSuccessState());
    } else
    {
      emit(AppPostImagePickedErrorState());
    }
  }

  Future<void> getPostImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      postImageFile.add(File(pickedFile.path));
      emit(AppPostImagePickedSuccessState());
    } else {
      emit(AppPostImagePickedErrorState());
    }
  }
  int i = 0;
  int j = 0;
  Map postsImagesMap ={};
  void uploadPostImage({
    required BuildContext context,
    required String text,
    required String dateTime,
  }) {
    i = 0;
    emit(AppCreatePostLoadingState());
    postImageFile.forEach((element) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(element.path).pathSegments.last}')
          .putFile(element).whenComplete((){ })
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          postsImagesMap['$i'] = value.toString();
          i++;
          if(postsImagesMap.length == postImageFile.length ) {
            createPost(context: context, text: text, dateTime: dateTime);
          }
        }).catchError((error) {
          emit(AppCreatePostErrorState());
        });
      }).catchError((error) {
        emit(AppCreatePostErrorState());
      });
    });
  }

  void createPost({
    required BuildContext context,
    required String text,
    required String dateTime,
  }) {
          emit(AppCreatePostLoadingState());
          PostModel newPostModel = PostModel(
            name: model!.name,
            userImage: model?.userImage,
            location: model?.location,
            uId: model?.uId.toString(),
            postText: text,
            dateTime: dateTime,
            postImages: postsImagesMap,
            likes: {},
          );

          FirebaseFirestore.instance
              .collection('posts')
              .add(newPostModel.toMap())
              .then((value) {
            emit(AppCreatePostSuccessState());
            postImageFile.clear();
            postsImagesMap.clear();
            Navigator.pop(context);
          }).catchError((error) {
            emit(AppUserUpdateErrorState());
          });


  }

  ///---------- add like post ----------

  void likeChange({required String postId, required String key}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
      Map? likes = PostModel.fromJson(value.data()).likes;
      if (likes![key] == true) {
        likes[key] = false;
      } else {
        likes[key] = true;
      }

      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update({'likes': likes})
          .then((value) {})
          .catchError((error) {});
    }).catchError((error) {});
  }

  ///---------- get all users ----------

  List<UserModel> users = [];
  List<UserModel> myuser = [];
  void getUsers() {
    users = [];
    FirebaseFirestore.instance.collection('person').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] == model?.uId) {
          myuser.add(UserModel.fromJson(element.data()));
        }
        if (element.data()['uId'] != model?.uId) {
          users.add(UserModel.fromJson(element.data()));
        }
      }
      emit(AppGetAllUsersSuccessState());
    }).catchError((error) {
      emit(AppGetAllUsersErrorState(error.toString()));
      print(error.toString());
    });
  }

  ///---------- send message ----------

  List<MessageModel> messages = [];
  
  void sendMessage({
    required String? image,
    required String? name,
    required Map<String, dynamic>? chatList,
    required String token,
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
        .collection('person')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      DioHelper.sendFcmMessage(title: model.name, message: text, token: token)
          .then((value) {})
          .catchError((error) {});
      emit(AppSendMessageSuccessState());
    }).catchError((error) {
      emit(AppSendMessageErrorState());
    });
    Map<String, dynamic>? mm = model.chatList;
    mm?.addAll({receiverId.toString():[text,dateTime,image,name]});
    FirebaseFirestore.instance
        .collection('person')
        .doc(model!.uId).update({'chatList': mm })
        .then((value) {}).catchError((e){print(e.toString());});

    FirebaseFirestore.instance
        .collection('person')
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

    Map<String, dynamic>? m = chatList;
    m?.addAll({model.uId.toString():[text,dateTime,model.userImage,model.name]});
    FirebaseFirestore.instance
        .collection('person')
        .doc(receiverId).update({
      'chatList': m })
        .then((value) {}).catchError((e){print(e.toString());});
  }

  ///---------- get all messages ----------
  
  void getMessages({required String? receiverId}) {
    FirebaseFirestore.instance
        .collection('person')
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

  ///---------- get search results ---------

  List<dynamic> search = [];
  void getSearchData(String value) {
    emit(AppLoadingState());
    FirebaseFirestore.instance
        .collection('person')
        .where('name', isEqualTo: value)
        .get()
        .then((value) {
      search = [];
      value.docs.forEach((element) {
        search.add(element.data());
        emit(AppLoadingState());
      });
    }).catchError((error) {});
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
    if (idCardImage != null) {
      uploadIdCardImage();
    }

    if (hasProfession == true)
    {
      emit(AppTechnicianUpdateLoadingState());
      TechnicianModel newModel = TechnicianModel(
        name: name,
        uId: model!.uId,
        phone: phone,
        bio: bio,
        chatList:model.chatList,
        nationalId: nationalId,
        idCardPhoto: uploadedIdCardImage,
        location: location,
        token: model.token,
        profession: profession,
        userImage: uploadedProfileImage,
        coverImage: uploadedProfileImage,
        hasProfession: true,
        latitude: model.latitude,
        longitude: model.longitude,
      );
      FirebaseFirestore.instance
          .collection('person')
          .doc(uId)
          .set(newModel.toMap())
          .then((value) {
        getUserData();
        Navigator.pop(context);
      }).catchError((error) {
        emit(AppTechnicianUpdateErrorState());
      });
    }
    else if (hasProfession == false)
    {
      emit(AppUserUpdateLoadingState());
      UserModel newModel = UserModel(
        name: name,
        phone: phone,
        location: location,
        token: model.token,
        chatList: model.chatList,
        userImage: uploadedProfileImage ?? model?.userImage,
        coverImage: uploadedCoverImage ?? model?.coverImage,
        uId: uId,
        hasProfession: false,
        latitude: model.latitude,
        longitude: model.longitude,
      );
      FirebaseFirestore.instance
          .collection('person')
          .doc(uId)
          .set(newModel.toMap())
          .then((value) {
        getUserData();
        Navigator.pop(context);
      }).catchError((error) {
        emit(AppUserUpdateErrorState());
      });
    }
  }

}