import 'package:online_technician/models/user.dart';

class TechnicianModel extends UserModel {
  String? bio;
  String? nationalId;
  String? idCardPhoto;
  String? profession;

  TechnicianModel({
    String? name,
    Map<String, dynamic>? chatList,
    String? uId,
    String? userImage,
    String? phone,
    String? coverImage,
    bool? hasProfession,
    String? location,
    String? latitude,
    String? longitude,
    String? token,
    this.bio,
    this.profession,
    this.nationalId,
    this.idCardPhoto,
  }) : super(
          name: name,
          uId: uId,
          chatList: chatList,
          userImage: userImage,
          phone: phone,
          coverImage: coverImage,
          hasProfession: hasProfession,
          location: location,
          latitude:latitude,
          longitude:longitude,
          token: token,
        );

  TechnicianModel.fromJson(Map<String, dynamic>? json)
      : super(
            name: json!['name'],
            chatList: json['chatList'],
            uId: json['uId'],
            userImage: json['userImage'],
            phone: json['phone'],
            coverImage: json['coverImage'],
            hasProfession: json['hasProfession'],
            location: json['location'],
            latitude:json['latitude'],
            longitude:json['longitude'],
            token: json['token'],
  )
  {
    bio = json['bio'];
    profession =json['profession'];
    nationalId = json['nationalId'];
    idCardPhoto = json['idCardPhoto'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'nationalId': nationalId,
      'idCardPhoto': idCardPhoto,
      'phone': phone,
      'chatList':chatList,
      'coverImage': coverImage,
      'hasProfession': hasProfession,
      'name': name,
      'uId': uId,
      'userImage': userImage,
      'location': location,
      'profession': profession,
      'latitude':latitude,
      'longitude':longitude,
      'token':token,
    };
  }
}
