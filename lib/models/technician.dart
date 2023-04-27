import 'package:online_technician/models/user.dart';

class TechnicianModel extends UserModel {
  String? bio;
  String? nationalId;
  String? idCardPhoto;
  String? profession;
  String? positive;
  String? neutral;
  String? negative;

  TechnicianModel({
    String? name,
    Map<String, dynamic>? chatList,
    String? uId,
    String? userImage,
    String? phone,
    bool? hasProfession,
    String? location,
    String? latitude,
    String? longitude,
    String? token,
    Map<String, dynamic>? sentRequests,
    Map<String, dynamic>? receivedRequests,
    Map<String, dynamic>? notificationList,
    this.bio,
    this.profession,
    this.nationalId,
    this.idCardPhoto,
    this.positive,
    this.neutral,
    this.negative,
  }) : super(
            name: name,
            uId: uId,
            chatList: chatList,
            userImage: userImage,
            phone: phone,
            hasProfession: hasProfession,
            location: location,
            latitude: latitude,
            longitude: longitude,
            token: token,
            receivedRequests: receivedRequests,
            sentRequests: sentRequests,
            notificationList: notificationList
  );

  TechnicianModel.fromJson(Map<String, dynamic>? json)
      : super(
          name: json!['name'],
          chatList: json['chatList'],
          uId: json['uId'],
          userImage: json['userImage'],
          phone: json['phone'],
          hasProfession: json['hasProfession'],
          location: json['location'],
          latitude: json['latitude'],
          longitude: json['longitude'],
          token: json['token'],
          sentRequests: json['sentRequests'],
          receivedRequests: json['receivedRequests'],
          notificationList: json['notificationList'],
        ) {
    bio = json['bio'];
    profession = json['profession'];
    nationalId = json['nationalId'];
    idCardPhoto = json['idCardPhoto'];
    positive = json['positive'];
    neutral = json['neutral'];
    negative = json['negative'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'nationalId': nationalId,
      'idCardPhoto': idCardPhoto,
      'phone': phone,
      'chatList': chatList,
      'hasProfession': hasProfession,
      'name': name,
      'uId': uId,
      'userImage': userImage,
      'location': location,
      'profession': profession,
      'latitude': latitude,
      'longitude': longitude,
      'token': token,
      'sentRequests': sentRequests,
      'receivedRequests': receivedRequests,
      'notificationList': notificationList,
    };
  }
}
