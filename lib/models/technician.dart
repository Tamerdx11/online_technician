import 'package:online_technician/models/user.dart';

class TechnicianModel extends UserModel{
  String? bio;
  String? nationalId;
  String? idCardPhoto;

  TechnicianModel({
    String? name,
    String? uId,
    String? userImage,
    String? phone,
    String? email,
    String? coverImage,
    bool? hasProfession,
    String? location,
    String? profession,
    this.bio,
    this.nationalId,
    this.idCardPhoto,
  }) : super(
            name: name,
            uId: uId,
            userImage: userImage,
            phone: phone,
            email: email,
            coverImage: coverImage,
            hasProfession: true,
            location: location,
            profession:profession,
  );

  TechnicianModel.fromJson(Map<String, dynamic>? json)
      : super(
            name: json!['name'],
            uId: json['uId'],
            userImage: json['userImage'],
            phone: json['phone'],
            email: json['email'],
            coverImage: json['coverImage'],
            hasProfession: json['hasProfession'],
            location: json['location'],
            profession: json['profession'])
  {
    bio = json['bio'];
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
      'email': email,
      'coverImage': coverImage,
      'hasProfession': hasProfession,
      'name': name,
      'uId': uId,
      'userImage': userImage,
      'location': location,
      'profession': profession,
    };
  }
}