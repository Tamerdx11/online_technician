import 'package:online_technician/models/person.dart';

class UserModel extends PersonModel {
  String? phone;
  String? coverImage;
  String? token;
  bool? hasProfession;
  String? latitude;
  String? longitude;

  UserModel({
    String? name,
    String? uId,
    String? userImage,
    String? location,
    Map<String, dynamic>? chatList,
    Map<String, dynamic>? sentRequests,
    Map<String, dynamic>? receivedRequests,
    this.phone,
    this.token,
    this.coverImage,
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
            sentRequests: sentRequests);

  UserModel.fromJson(Map<String, dynamic>? json)
      : super(
          name: json!['name'],
          chatList: json['chatList'],
          uId: json['uId'],
          location: json['location'],
          userImage: json['userImage'],
          sentRequests: json['sentRequests'],
          receivedRequests: json['receivedRequests'],
        ) {
    phone = json['phone'];
    coverImage = json['coverImage'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    hasProfession = json['hasProfession'];
    token = json['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'coverImage': coverImage,
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
    };
  }
}
