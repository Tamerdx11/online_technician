import 'package:online_technician/models/person.dart';

class UserModel extends PersonModel {
  String? phone;
  String? email;
  String? coverImage;
  String? token;
  bool hasProfession = false;

  UserModel({
    String? name,
    String? uId,
    String? userImage,
    String? location,
    String? profession,
    this.phone,
    this.email,
    this.token,
    this.coverImage,
    required this.hasProfession,
  }) : super(
            name: name,
            uId: uId,
            userImage: userImage,
            location: location,
            profession: profession);

  UserModel.fromJson(Map<String, dynamic>? json)
      : super(
            name: json!['name'],
            uId: json['uId'],
            location: json['location'],
            userImage: json['userImage'],
            profession: json['profession']) {
    phone = json['phone'];
    email = json['email'];
    coverImage = json['coverImage'];
    hasProfession = json['hasProfession'];
    token = json['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'coverImage': coverImage,
      'hasProfession': hasProfession,
      'name': name,
      'uId': uId,
      'userImage': userImage,
      'location': location,
      'profession': profession,
      'token':token,
    };
  }
}
