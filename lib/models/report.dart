import 'package:online_technician/models/person.dart';

class ReportModel {
  String? notes;
  String? senderUsername;
  String? reportedUsername;
  String? senderUId;
  String? reportedUId;

  ReportModel({
    this.notes,
    this.senderUsername,
    this.reportedUsername,
    this.senderUId,
    this.reportedUId,
  });

  ReportModel.fromJson(Map<String, dynamic>? json) {
    notes = json!['notes'];
    senderUsername = json['senderUsername'];
    reportedUsername = json['reportedUsername'];
    senderUId = json['senderUId'];
    reportedUId = json['reportedUId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'senderUsername': senderUsername,
      'reportedUsername': reportedUsername,
      'senderUId': senderUId,
      'reportedUId': reportedUId,
    };
  }
}
