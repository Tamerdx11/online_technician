import 'package:online_technician/models/person.dart';

class UserModel extends PersonModel {
  String? phone;
  String? token;
  bool? hasProfession;
  String? latitude;
  String? longitude;

  UserModel({
    String? name,
    String? uId,
    String? userImage,
    String? location,
    String? positive,
    String? neutral,
    String? negative,
    Map<String, dynamic>? chatList,
    Map<String, dynamic>? sentRequests,
    Map<String, dynamic>? receivedRequests,
    Map<String, dynamic>? notificationList,
    this.phone,
    this.token,
    this.hasProfession,
    this.latitude,
    this.longitude,
  }) : super(
            name: name,
            uId: uId,
            chatList: chatList,
            userImage: userImage,
            location: location,
            receivedRequests: receivedRequests,
            sentRequests: sentRequests,
            notificationList: notificationList,
            positive: positive,
            negative: negative,
            neutral: neutral);

  UserModel.fromJson(Map<String, dynamic>? json)
      : super(
          name: json!['name'],
          chatList: json['chatList'],
          uId: json['uId'],
          location: json['location'],
          userImage: json['userImage'],
          sentRequests: json['sentRequests'],
          receivedRequests: json['receivedRequests'],
          notificationList: json['notificationList'],
          positive: json['positive'],
          negative: json['negative'],
          neutral: json['neutral'],
        ) {
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    hasProfession = json['hasProfession'];
    token = json['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'hasProfession': hasProfession,
      'name': name,
      'uId': uId,
      'chatList': chatList,
      'userImage': userImage,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'sentRequests': sentRequests,
      'receivedRequests': receivedRequests,
      'notificationList': notificationList,
      'positive': positive,
      'negative': negative,
      'neutral': neutral
    };
  }
}
