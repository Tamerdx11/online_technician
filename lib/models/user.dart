import 'package:online_technician/models/person.dart';

class UserModel extends PersonModel {
  String? phone;
  String? coverImage;
  String? token;
  bool hasProfession = false;
  String? latitude;
  String? longitude;

  UserModel({
    String? name,
    String? uId,
    String? userImage,
    String? location,
    Map<String, dynamic>? chatList,
    this.phone,
    this.token,
    this.coverImage,
    required this.hasProfession,
    this.latitude,
    this.longitude,
  }) : super(
            name: name,
            uId: uId,
            chatList: chatList,
            userImage: userImage,
            location: location,);

  UserModel.fromJson(Map<String, dynamic>? json)
      : super(
            name: json!['name'],
            chatList: json['chatList'],
            uId: json['uId'],
            location: json['location'],
            userImage: json['userImage'],) {
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
      'chatList':chatList,
      'userImage': userImage,
      'location': location,
      'latitude':latitude,
      'longitude':longitude,
      'token':token,
    };
  }
}
