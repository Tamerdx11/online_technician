import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_technician/models/message.dart';
import 'package:online_technician/models/post.dart';
import 'package:online_technician/models/technician.dart';
import 'package:online_technician/models/user.dart';
import 'package:online_technician/modules/chat_details/chat_details_screen.dart';
import 'package:online_technician/modules/feeds/feeds_screen.dart';
import 'package:online_technician/modules/google_map2/GoogleMaps2.dart';
import 'package:online_technician/modules/search/search_screen.dart';
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
        .get()
        .then((value) {
      if (value.data()!['hasProfession'] == true) {
        CacheHelper.savaData(key: 'hasProfession', value: true);
        model = TechnicianModel.fromJson(value.data());
        emit(AppGetUserSuccessState());
      } else {
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
    }).catchError((error) {
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  ///-----------get data for chat person----------

  void goToChatDetails(String id, BuildContext context) {
    FirebaseFirestore.instance
        .collection('person')
        .doc(id.toString())
        .get()
        .then((value) {
      navigateTo(
        context,
        ChatDetailsScreen(
          userModel: UserModel.fromJson(value.data()),
        ),
      );
    }).catchError((error) {});
  }

  ///---------- main layout navigation ----------

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedsScreen(),
    const NotificationScreen(),
    const SentRequestsScreen(),
    const ReceivedRequestsScreen(),
  ];
  List<BottomNavigationBarItem> bottomItems1 = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_sharp),
      label: "الرئيسية",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications_active),
      label: "الأشعارات",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.hail),
      label: "طلباتي",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.handyman_sharp),
      label: "طلبات عمل",
    )
  ];
  List<BottomNavigationBarItem> bottomItems2 = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_sharp),
      label: "الرئيسية",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications_active),
      label: "الأشعارات",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.hail),
      label: "طلباتي",
    ),
  ];

  void changeButtonNav(int index) {
    currentIndex = index;
    emit(AppChangeButtonNavState());
  }

  var curr_index = 0;
  void changeCarousel(var index) {
    curr_index = index;
    Timer(const Duration(milliseconds: 10), () {
      emit(AppChangeCarouselDotState());
    });
  }

  ///---------- create post ----------

  final picker = ImagePicker();
  List<File> postImageFile = [];

  void removePostImage({required int index}) {
    postImageFile.removeAt(index);
    emit(AppRemovePostImageState());
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImageFile.add(File(pickedFile.path));
      emit(AppPostImagePickedSuccessState());
    } else {
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
  Map postsImagesMap = {};
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
          .putFile(element)
          .whenComplete(() {})
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          postsImagesMap['$i'] = value.toString();
          i++;
          if (postsImagesMap.length == postImageFile.length) {
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

  ///---------- get one users ----------

  UserModel? user;
  Future<void> getUser(String id) async {
    await FirebaseFirestore.instance
        .collection('person')
        .doc(id)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data());
      emit(AppGetAllUsersSuccessState());
    }).catchError((error) {});
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
    mm?.addAll({
      receiverId.toString(): [text, dateTime, image, name]
    });

    FirebaseFirestore.instance
        .collection('person')
        .doc(model!.uId)
        .update({'chatList': mm})
        .then((value) {})
        .catchError((e) {
          print(e.toString());
        });

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
    m?.addAll({
      model.uId.toString(): [text, dateTime, model.userImage, model.name]
    });
    FirebaseFirestore.instance
        .collection('person')
        .doc(receiverId)
        .update({'chatList': m})
        .then((value) {})
        .catchError((e) {
          print(e.toString());
        });
  }

  ///---------- send request to tech ----------

  void sendRequestToTech({
    required String? techId,
    required String? name,
    required String? image,
    required Map<String, dynamic>? techReceivedRequests,
    required int fDay,
    required int fMonth,
    required int fYear,
    required String? details,
    required String? latitude,
    required String? longitude,
    required String? location,
    required String? token,
  }) {
    emit(AppSendingRequestState());
    ///------fix my requests-------
    Map<String, dynamic>? mySendRequests = model.sentRequests;
    mySendRequests?.addAll({
      techId.toString(): {
        'name':name,
        'image':image,
        'deadline':[fYear,fMonth,fDay],
        'details':details,
        'location':location,
        'latitude':latitude,
        'longitude':longitude,
        'isAccepted':false,
        'isRejected':false,
        'isDeadline':false,
        'isRated':false
      }
    });

    FirebaseFirestore.instance
        .collection('person')
        .doc(model!.uId)
        .update({'sentRequests': mySendRequests})
        .then((value) {})
        .catchError((e) {
      emit(AppErrorSendingState());
    });

    ///------fix tech requests------
    Map<String, dynamic>? receivedRequests = techReceivedRequests;
    receivedRequests?.addAll({
      uId.toString(): {
        'name':model.name,
        'image':model.userImage,
        'deadline':[fYear,fMonth,fDay],
        'details':details,
        'location':model.location,
        'latitude':model.latitude,
        'longitude':model.longitude,
        'isAccepted':false,
        'isRejected':false,
        'isDeadline':false,
        'isRated':false
      }
    });

    FirebaseFirestore.instance
        .collection('person')
        .doc(techId.toString())
        .update({'receivedRequests': receivedRequests})
        .then((value) {
      emit(AppSuccessSendingState());
          showToast(text: 'تم ارسال طلبك بنجاح', state: ToastState.SUCCESS);
      DioHelper.sendFcmMessage(title: 'طلب عمل من ${model.name}', message: details, token: token)
          .then((value) {})
          .catchError((error) {});
    })
        .catchError((e) {
      emit(AppErrorSendingState());
    });
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
  Map searchunorderwd = {};
  Map searchOrderwd = {};
  void getSearchData(String value, String key) {
    emit(AppLoadingState1());
    FirebaseFirestore.instance
        .collection('person')
        .where(key, isEqualTo: value)
        .get()
        .then((value) {
      search = [];
      searchunorderwd ={};
      value.docs.forEach((element) {
        if (element.data()['uId'] != uId) {
          searchunorderwd.addAll({
            element.data()['uId']:[
              element.data()
              ,getDistance(
                  lat1: model.latitude,
                  long1: model.longitude,
                  lat2: element.data()['latitude'],
                  long2: element.data()['longitude'],
              )
            ]
          });
          emit(AppLoadingState());
        }
      });
      searchOrderwd = Map.fromEntries(
          searchunorderwd.entries.toList()..sort((e1, e2) => e1.value[1].compareTo(e2.value[1]))
      );
      searchOrderwd.forEach((key, value) {
        search.add(value.first);
      });
      if(search.length == 0){
        emit(AppEmptySearchState());
      }
      emit(AppLoadingState());
    }).catchError((error) {
    });
  }

  ///---------- change search item ---------

  List values = ['name', 'profession'];
  String searchItem = 'profession';
  void changeSearchItem(value){
    searchItem = value;
    emit(AppChangeSearchItemState());
  }

  ///------------ has profession change ---------------

  late bool hasProfession = model.hasProfession;
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
        .child('users/$uId$uId$uId')
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
        .child('users/$uId')
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
        .child('users/$uId$uId')
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

  String? profession = 'نقاش';
  void changeValue(String? value) {
    profession = value;
    emit(change());
  }

  void updateProfileDate({
    String? name,
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

    emit(AppTechnicianUpdateLoadingState());
    Timer(const Duration(seconds: 5), () {
      if (hasProfession == true) {
        emit(AppTechnicianUpdateLoadingState());
        TechnicianModel newModel = TechnicianModel(
          name: name,
          uId: model!.uId,
          phone: model.phone,
          bio: bio,
          chatList: model.chatList,
          nationalId: nationalId,
          idCardPhoto: uploadedIdCardImage ?? model?.idCardPhoto,
          location: location,
          token: model.token,
          profession: profession,
          userImage: uploadedProfileImage ?? model?.userImage.toString(),
          coverImage: uploadedCoverImage ?? model?.coverImage.toString(),
          hasProfession: true,
          latitude: latitude != 0 ? latitude.toString() : model.latitude,
          longitude: longitude != 0 ? longitude.toString() : model.longitude,
          sentRequests: model.sentRequests??{},
          receivedRequests: model.receivedRequests??{},
        );
        if (idCardImage == null && model?.idCardPhoto == null) {
          showToast(text: 'صورة البطاقة غير موجودة', state: ToastState.ERROR);
          emit(
            AppUserUpdateErrorState(),
          );
        } else {
          FirebaseFirestore.instance
              .collection('person')
              .doc(uId)
              .set(newModel.toMap())
              .then((value) {
            CacheHelper.savaData(key: 'hasProfession', value: true);
            getUserData();
            emit(AppTechnicianUpdateSuccessState());
          }).catchError((error) {
            emit(AppTechnicianUpdateErrorState());
          });
        }
      } else if (hasProfession == false) {
        emit(AppUserUpdateLoadingState());
        UserModel newModel = UserModel(
          name: name,
          phone: model.phone,
          location: location,
          token: model.token,
          chatList: model.chatList,
          userImage: uploadedProfileImage ?? model?.userImage,
          coverImage: uploadedCoverImage ?? model?.coverImage,
          uId: uId,
          hasProfession: false,
          latitude: latitude != 0 ? latitude.toString() : model.latitude,
          longitude: longitude != 0 ? longitude.toString() : model.longitude,
          sentRequests: model.sentRequests??{},
          receivedRequests: model.receivedRequests??{},
        );
        FirebaseFirestore.instance
            .collection('person')
            .doc(uId)
            .set(newModel.toMap())
            .then((value) {
          CacheHelper.savaData(key: 'hasProfession', value: false);
          getUserData();
          emit(AppTechnicianUpdateSuccessState());
        }).catchError((error) {
          emit(AppUserUpdateErrorState());
        });
      }
    });
  }

  ///---------------------get distance ----------------------

  double getDistance({
    required String lat1,
    required String long1,
    required String lat2,
    required String long2,
  }) {
    HaversineDistance g = HaversineDistance(4,5,6,7);
    LatLng from=LatLng(double.parse(lat1) , double.parse(long1));
    LatLng to=LatLng(double.parse(lat2) , double.parse(long2));
    double distance = g.haversine(from.latitude, from.longitude, to.latitude, to.longitude, Unit.KM);
    return distance;
  }
}