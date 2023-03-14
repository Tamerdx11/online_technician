import 'package:online_technician/models/person.dart';

class ReportModel extends PersonModel {
  String? notes;
  ReportModel({
    String? name,
    String? uId,
    this.notes,

  }) : super(name: name, uId: uId,);

  ReportModel.fromJson(Map<String, dynamic>? json)
      : super(
      name: json!['name'],
      uId: json['uId'],){
    notes = json['notes'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'notes': notes,
    };
  }
}
