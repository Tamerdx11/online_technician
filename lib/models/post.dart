import 'package:online_technician/models/person.dart';

class PostModel extends PersonModel {
  String? postText;
  List<String>? postImages;
  String? dateTime;

  PostModel({
    String? name,
    String? uId,
    String? userImage,
    String? location,
    this.postText,
    this.postImages,
    this.dateTime,
  }) : super(name: name, uId: uId, userImage: userImage, location: location);

  PostModel.fromJson(Map<String, dynamic>? json)
      : super(
            name: json!['name'],
            uId: json['uId'],
            userImage: json['userImage'],
            location: json['location'])
  {
    postText = json['postText'];
    postImages = json['postImages'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'postText': postText,
      'postImages': postImages,
      'dateTime': dateTime,
      'name': name,
      'uId': uId,
      'userImage': userImage,
      'location': location,
    };
  }
}
