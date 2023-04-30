import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geocoding/geocoding.dart';
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
import '../../models/report.dart';
import '../../modules/login/login_screen.dart';
import '../../modules/report/report.dart';
import '../components/components.dart';
import 'package:http/http.dart' as http;

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  final storageRef = firebase_storage.FirebaseStorage.instance.ref();

  ///---------- get person data ------------

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

  ///***** API ****
  var result;
  double max = 0;
  int indicator = 0;
  int total = 0;

  void testApi({
    required String userid,
    required String text,
  }) {
    String? positive = tech!.positive;
    String? neutral = tech!.neutral;
    String? negative = tech!.negative;
    emit(apiloading());
    DioHelper.postData(
      url: '/models/Ammar-alhaj-ali/arabic-MARBERT-sentiment',
      data: {"inputs": text},
    ).then((value) {
      result = value.data;
      print("========================text====================");
      print(text);
      print("=====================================================test API====================");
      print(result);
      print("-------------------------------------------best result-------------------------");
      print(result[0][indicator]["label"]);
      print(result[0][0]["score"]);
      for (int i = 0; i < 3; i++) {
        if (i == 0) {
          max = result[0][0]["score"];
        } else {
          if (max < result[0][i]["score"]) {
            max = result[0][i]["score"];
            indicator = i;
          }
        }
      }
      if (positive == "") {
        positive = "0";
      }
      if (neutral == "") {
        neutral = "0";
      }
      if (negative == "") {
        negative = "0";
      }
      if (result[0][indicator]["label"] == "positive") {
        print(positive);
        total = int.parse(positive!) + 1;
      }
      if (result[0][indicator]["label"] == "neutral") {
        total = int.parse(neutral!) + 1;
      }
      if (result[0][indicator]["label"] == "negative") {
        total = int.parse(negative!) + 1;
      }
      sendRate(
          userid: userid,
          rate: result[0][indicator]["label"],
          total: total.toString());
      print("=====================================================test API 2====================");
      print(result);
      print(result[0][indicator]["label"]);
      print(max);
      print(total);
      print(result[0][indicator]["label"]);
      print(userid);
      emit(apisuccesstate());
    }).catchError((error) {
      print(error.toString());
      emit(apierrrorstate((error).toString()));
    });
  }

  void sendRate({
    required String userid,
    required String rate,
    required String total,
  }) {
    FirebaseFirestore.instance
        .collection('person')
        .doc(userid)
        .update({rate: total}).then((value) {
      print('11111111111111111111111111111111111111111111111111111');
      print(total);
      print(userid);
    }).catchError((error) {
      print('99999999999999999999999999999999999999999999999');
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

  ///---------- get data for report person ----------

  void createReportedUser(
      {required String notes,
      required String reportedUId,
      required String senderUId,
      required String dateReport,
      required String reportedUsername,
      required String senderUsername,
      required BuildContext context}) {
    ReportModel newReport = ReportModel(
      notes: notes,
      reportedUId: reportedUId,
      senderUId: senderUId,
      reportedUsername: reportedUsername,
      senderUsername: senderUsername,
      dateReport: dateReport,
    );
    FirebaseFirestore.instance
        .collection('reports')
        .add(newReport.toMap())
        .then((value) {
      Navigator.pop(context);
      pushNotification(
          id: uId,
          notificationList: model!.notificationList,
          isClickable: false,
          notificationId: '5$uId',
          navigateTo: '',
          text: 'تم تلقي بلاغك عن $reportedUsername وسوف نقوم بمراجعة بلاغك ');
      emit(CreatReportedUserSuccessState());
    }).catchError((error) {
      emit(CreatReportedUserSuccessState());
    });
  }

  ///---------- main layout navigation --------------

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
  Map<String, dynamic>? userSendRequests = {};
  Future<void> getUser(String id) async {
    await FirebaseFirestore.instance
        .collection('person')
        .doc(id)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data());
      userSendRequests = user?.sentRequests;
      emit(AppGetAllUsersSuccessState());
    }).catchError((error) {});
  }

  TechnicianModel? tech;
  Future<void> getTech(String id) async {
    await FirebaseFirestore.instance
        .collection('person')
        .doc(id)
        .get()
        .then((value) {
      tech = TechnicianModel.fromJson(value.data());
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

    ///**************re***********

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

  ///---------- change request status ----------

  void changeRequestStatus({
    required String? userId,
    required Map<String, dynamic>? techSendRequests,
    required String? token,
    required bool status,
  }) {
    emit(AppSendingRequestState());

    ///------fix my requests-------
    Map<String, dynamic>? myReceivedRequests = model.receivedRequests;
    myReceivedRequests![userId]['isAccepted'] = status;
    myReceivedRequests[userId]['isRejected'] = !status;
    myReceivedRequests[userId]['isDone'] = !status;

    FirebaseFirestore.instance
        .collection('person')
        .doc(model!.uId)
        .update({'receivedRequests': myReceivedRequests})
        .then((value) {})
        .catchError((e) {
          emit(AppErrorSendingState());
        });

    ///------fix tech requests------
    Map<String, dynamic>? newTechSendRequests = techSendRequests;
    newTechSendRequests![uId.toString()]['isAccepted'] = status;
    newTechSendRequests[uId.toString()]['isRejected'] = !status;
    newTechSendRequests[uId.toString()]['isDone'] = !status;

    FirebaseFirestore.instance
        .collection('person')
        .doc(userId.toString())
        .update({'sentRequests': newTechSendRequests}).then((value) {
      emit(AppChangeStatusState());
      DioHelper.sendFcmMessage(
              title: status
                  ? 'تم الموافقة علي طلب العمل من  ${model.name}'
                  : 'تم رفض طلبك من قبل  ${model.name}',
              message: ' ',
              token: token)
          .then((value) {})
          .catchError((error) {});
    }).catchError((e) {
      emit(AppErrorSendingState());
    });
  }

  ///---------- send request to tech ----------

  void sendRequestToTech({
    required String? techId,
    required String? profession,
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
        'name': name,
        'image': image,
        'deadline': [fYear, fMonth, fDay],
        'details': details,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'profession': profession,
        'isAccepted': false,
        'isRejected': false,
        'isDeadline': false,
        'isRated': false,
        'isDone': false,
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
        'name': model.name,
        'image': model.userImage,
        'deadline': [fYear, fMonth, fDay],
        'details': details,
        'location': model.location,
        'latitude': model.latitude,
        'longitude': model.longitude,
        'isAccepted': false,
        'isRejected': false,
        'isDeadline': false,
        'isRated': false,
        'isDone': false
      }
    });

    FirebaseFirestore.instance
        .collection('person')
        .doc(techId.toString())
        .update({'receivedRequests': receivedRequests}).then((value) {
      emit(AppSuccessSendingState());
      showToast(text: 'تم ارسال طلبك بنجاح', state: ToastState.SUCCESS);
      DioHelper.sendFcmMessage(
              title: 'طلب عمل من ${model.name}', message: details, token: token)
          .then((value) {})
          .catchError((error) {});
    }).catchError((e) {
      emit(AppErrorSendingState());
    });
  }

  ///------------- Received requests checker -------------------

  void receivedRequestsChecker({
    required bool isAccepted,
    required bool isRejected,
    required bool isRated,
    required bool isDeadline,
    required String? userId,
    required int day,
    required int month,
    required int year,
  }) {
    FirebaseFirestore.instance
        .collection('person')
        .doc(userId)
        .get()
        .then((value) {
      var user2 = UserModel.fromJson(value.data());
      if (checkRequestDeadline(day: day, month: month, year: year)) {
        if (isDeadline == false) {
          changeReceivedRequestStates(
              senderRequests: user2.sentRequests,
              userId: userId,
              deadline: true,
              accepted: isAccepted,
              done: false,
              rated: isRated,
              rejected: isRejected);
        }
        if (isAccepted == true && isRejected == false) {
          DioHelper.sendFcmMessage(
            title: 'المجتمع المهني',
            message:
                'تم أنتهاء الموعد المحدد لأحد طلبات العمل التي قمت بإرسالها مسبقا الي ${model.name}',
            token: user2.token.toString(),
          );
          pushNotification(
            id: userId,
            notificationList: user2.notificationList,
            notificationId: '6$uId',
            text: 'تم الانتهاء الموعد المحدد لأحد الطلبات المرسلة',
            isClickable: true,
            navigateTo: "SendRequestsScreen",
          );
        } else if (isAccepted == false && isRejected == true) {
          changeReceivedRequestStates(
              senderRequests: user2.sentRequests,
              userId: userId,
              deadline: true,
              accepted: isAccepted,
              done: true,
              rated: isRated,
              rejected: isRejected);
        } else if (isAccepted == false && isRejected == false) {
          changeReceivedRequestStates(
            senderRequests: user2.sentRequests,
            userId: userId,
            deadline: true,
            accepted: isAccepted,
            done: true,
            rated: isRated,
            rejected: isRejected,
          );
        }
      }
    }).catchError((error) {});
  }

  /// ----------------- request deadline check -----------------

  bool checkRequestDeadline({
    required int day,
    required int month,
    required int year,
  }) {
    if (DateTime.now().year > year) {
      return true;
    } else if (DateTime.now().year < year) {
      return false;
    } else if (DateTime.now().year == year) {
      if (DateTime.now().month > month) {
        /// change to deadlined   *******
        return true;
      } else if (DateTime.now().month < month) {
        return false;
      } else if (DateTime.now().month == month) {
        if (DateTime.now().day > day) {
          return true;
        } else if (DateTime.now().day < day) {
          return false;
        } else if (DateTime.now().day == day) {
          return false;
        }
      }
    }
    return false;
  }

  /// ------------ change my received requests to deadlined --------------

  void changeReceivedRequestStates({
    required String? userId,
    required Map<String, dynamic>? senderRequests,
    required bool deadline,
    required bool done,
    required bool rated,
    required bool accepted,
    required bool rejected,
  }) {
    emit(AppSendingRequestState());

    ///------fix my requests-------
    Map<String, dynamic>? myReceivedRequests = model.receivedRequests;
    myReceivedRequests![userId]['isDeadline'] = deadline;
    myReceivedRequests[userId]['isAccepted'] = accepted;
    myReceivedRequests[userId]['isRejected'] = rejected;
    myReceivedRequests[userId]['isRated'] = rated;
    myReceivedRequests[userId]['isDone'] = done;

    FirebaseFirestore.instance
        .collection('person')
        .doc(model!.uId)
        .update({'receivedRequests': myReceivedRequests})
        .then((value) {})
        .catchError((e) {
          emit(AppErrorSendingState());
        });

    ///------fix user requests------
    Map<String, dynamic>? newSendRequests = senderRequests;
    newSendRequests![uId.toString()]['isDeadline'] = deadline;
    newSendRequests[uId.toString()]['isAccepted'] = accepted;
    newSendRequests[uId.toString()]['isRejected'] = rejected;
    newSendRequests[uId.toString()]['isRated'] = rated;
    newSendRequests[uId.toString()]['isDone'] = done;

    FirebaseFirestore.instance
        .collection('person')
        .doc(userId.toString())
        .update({'sentRequests': newSendRequests}).then((value) {
      emit(AppChangeStatusState());
    }).catchError((e) {
      emit(AppErrorSendingState());
    });
  }

  ///--------------- Send requests checker ------------------

  void sendRequestsChecker({
    required bool isAccepted,
    required bool isRejected,
    required bool isRated,
    required bool isDeadline,
    required String? userId,
    required int day,
    required int month,
    required int year,
  }) {
    FirebaseFirestore.instance
        .collection('person')
        .doc(userId)
        .get()
        .then((value) {
      TechnicianModel tech = TechnicianModel.fromJson(value.data());
      if (checkRequestDeadline(day: day, month: month, year: year)) {
        if (isDeadline == false) {
          changeSendRequestStates(
            techReceivedRequests: tech.receivedRequests,
            userId: userId,
            deadline: true,
            accepted: isAccepted,
            done: false,
            rated: isRated,
            rejected: isRejected,
          );
        }
        if (isAccepted == true && isRejected == false && isRated == false) {
          pushNotification(
            id: uId,
            text: 'تم الانتهاء من أحد الطلبات التي قمت بإرسالها',
            notificationId: '8$uId',
            isClickable: true,
            navigateTo: 'SentRequestsScreen',
            notificationList: model.notificationList,
          );
        } else if (isAccepted == false && isRejected == true) {
          changeSendRequestStates(
              techReceivedRequests: tech.receivedRequests,
              userId: userId,
              deadline: true,
              accepted: isAccepted,
              done: true,
              rated: isRated,
              rejected: isRejected);
        } else if (isAccepted == false && isRejected == false) {
          changeSendRequestStates(
              techReceivedRequests: tech.receivedRequests,
              userId: userId,
              deadline: true,
              accepted: isAccepted,
              done: true,
              rated: isRated,
              rejected: isRejected);
        }
      }
    }).catchError((error) {});
  }

  /// ------------- change my send requests to deadlined ----------

  void changeSendRequestStates({
    required String? userId,
    required Map<String, dynamic>? techReceivedRequests,
    required bool deadline,
    required bool done,
    required bool rated,
    required bool accepted,
    required bool rejected,
  }) {
    emit(AppSendingRequestState());

    /// ------------- fix send my requests -------------
    Map<String, dynamic>? sentRequests = model.sentRequests;
    sentRequests![userId]['isDeadline'] = deadline;
    sentRequests[userId]['isAccepted'] = accepted;
    sentRequests[userId]['isRejected'] = rejected;
    sentRequests[userId]['isRated'] = rated;
    sentRequests[userId]['isDone'] = done;

    FirebaseFirestore.instance
        .collection('person')
        .doc(model!.uId)
        .update({'sentRequests': sentRequests})
        .then((value) {})
        .catchError((e) {
          emit(AppErrorSendingState());
        });

    /// ------------- fix tech requests ---------------
    Map<String, dynamic>? techReceivedRequests2 = techReceivedRequests;
    techReceivedRequests2?[uId.toString()]['isDeadline'] = deadline;
    techReceivedRequests2?[uId.toString()]['isAccepted'] = accepted;
    techReceivedRequests2?[uId.toString()]['isRejected'] = rejected;
    techReceivedRequests2?[uId.toString()]['isRated'] = rated;
    techReceivedRequests2?[uId.toString()]['isDone'] = done;

    FirebaseFirestore.instance
        .collection('person')
        .doc(userId.toString())
        .update({'receivedRequests': techReceivedRequests2}).then((value) {
      emit(AppChangeStatusState());
    }).catchError((e) {
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
  Map searchUnordered = {};
  Map searchOrdered = {};
  void getSearchData(String value, String key) {
    emit(AppLoadingState1());
    FirebaseFirestore.instance
        .collection('person')
        .where(key, isEqualTo: value)
        .get()
        .then((value) {
      search = [];
      searchUnordered = {};
      value.docs.forEach((element) {
        if (element.data()['uId'] != uId) {
          searchUnordered.addAll({
            element.data()['uId']: [
              element.data(),
              getDistance(
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
      searchOrdered = Map.fromEntries(searchUnordered.entries.toList()
        ..sort((e1, e2) => e1.value[1].compareTo(e2.value[1])));
      searchOrdered.forEach((key, value) {
        search.add(value.first);
      });
      if (search.length == 0) {
        emit(AppEmptySearchState());
      }
      emit(AppLoadingState());
    }).catchError((error) {});
  }

  /// -------------------- change search item -----------------

  List values = ['name', 'profession'];
  String searchItem = 'profession';
  void changeSearchItem(value) {
    searchItem = value;
    emit(AppChangeSearchItemState());
  }

  /// ------------------ has profession change ---------------

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

  /// --------------- pick imageProfile ---------------

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

  /// ---------- upload id card image ----------

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

  ///----------  update profile data ----------

  String? profession = 'نقاش';
  void changeValue(String? value) {
    profession = value;
    emit(change());
  }

  void updateProfileData({
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
          hasProfession: true,
          latitude: latitude != 0 ? latitude.toString() : model.latitude,
          longitude: longitude != 0 ? longitude.toString() : model.longitude,
          sentRequests: model.sentRequests ?? {},
          receivedRequests: model.receivedRequests ?? {},
          notificationList: model.notificationList ?? {},
          positive: model.positive??"",
          neutral: model.neutral??"",
          negative: model.negative??"",
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
          uId: uId,
          hasProfession: false,
          latitude: latitude != 0 ? latitude.toString() : model.latitude,
          longitude: longitude != 0 ? longitude.toString() : model.longitude,
          sentRequests: model.sentRequests ?? {},
          receivedRequests: model.receivedRequests ?? {},
          notificationList: model.notificationList ?? {},
          positive: model.positive??"",
          neutral: model.neutral??"",
          negative: model.negative??"",
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

  /// ------------------ get distance -------------------

  double getDistance({
    required String lat1,
    required String long1,
    required String lat2,
    required String long2,
  }) {
    HaversineDistance g = HaversineDistance(4, 5, 6, 7);
    LatLng from = LatLng(double.parse(lat1), double.parse(long1));
    LatLng to = LatLng(double.parse(lat2), double.parse(long2));
    double distance = g.haversine(
        from.latitude, from.longitude, to.latitude, to.longitude, Unit.KM);
    return distance;
  }

  /// --------------- push notification -------------

  void pushNotification({
    required String? id,
    required notificationId,
    required Map<String, dynamic>? notificationList,
    required String? text,
    required bool isClickable,
    required String? navigateTo,
  }) {
    var newNotificationList = notificationList;
    newNotificationList!.addAll({
      notificationId.toString(): {
        'text': text,
        'isClickable': isClickable,
        'navigateTo': navigateTo,
      }
    });

    FirebaseFirestore.instance
        .collection('person')
        .doc(id.toString())
        .update({'notificationList': newNotificationList})
        .then((value) {})
        .catchError((e) {});
  }

  ///------------------requests checker------------------

  void requestsChecker() {
    for (int i = 0; i < model.sentRequests.length; i++) {
      if (model.sentRequests[model.sentRequests.keys.toList()[i]]['isDone'] ==
          false) {
        sendRequestsChecker(
          isAccepted: model.sentRequests[model.sentRequests.keys.toList()[i]]
              ['isAccepted'],
          isRejected: model.sentRequests[model.sentRequests.keys.toList()[i]]
              ['isRejected'],
          isRated: model.sentRequests[model.sentRequests.keys.toList()[i]]
              ['isRated'],
          isDeadline: model.sentRequests[model.sentRequests.keys.toList()[i]]
              ['isDeadline'],
          userId: model.sentRequests.keys.toList()[i].toString(),
          day: model.sentRequests[model.sentRequests.keys.toList()[i]]
              ['deadline'][2],
          month: model.sentRequests[model.sentRequests.keys.toList()[i]]
              ['deadline'][1],
          year: model.sentRequests[model.sentRequests.keys.toList()[i]]
              ['deadline'][0],
        );
      }
    }

    for (int j = 0; j < model.receivedRequests.length; j++) {
      if (model.receivedRequests[model.receivedRequests.keys.toList()[j]]
              ['isDone'] ==
          false) {
        receivedRequestsChecker(
          isAccepted:
              model.receivedRequests[model.receivedRequests.keys.toList()[j]]
                  ['isAccepted'],
          isRejected:
              model.receivedRequests[model.receivedRequests.keys.toList()[j]]
                  ['isRejected'],
          isRated:
              model.receivedRequests[model.receivedRequests.keys.toList()[j]]
                  ['isRated'],
          isDeadline:
              model.receivedRequests[model.receivedRequests.keys.toList()[j]]
                  ['isDeadline'],
          userId: model.receivedRequests.keys.toList()[j].toString(),
          day: model.receivedRequests[model.receivedRequests.keys.toList()[j]]
              ['deadline'][2],
          month: model.receivedRequests[model.receivedRequests.keys.toList()[j]]
              ['deadline'][1],
          year: model.receivedRequests[model.receivedRequests.keys.toList()[j]]
              ['deadline'][0],
        );
      }
    }
  }
}
