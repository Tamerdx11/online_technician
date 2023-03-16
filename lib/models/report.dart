import 'package:online_technician/models/person.dart';

class ReportModel {
  String? notes;
  String? senderUsername;
  String? reportedUsername;
  String? senderUId;
  String? reportedUId;
  String? dateReport;

  ReportModel({
    this.notes,
    this.senderUsername,
    this.reportedUsername,
    this.senderUId,
    this.reportedUId,
    this.dateReport,
  });

  ReportModel.fromJson(Map<String, dynamic>? json) {
    notes = json!['notes'];
    senderUsername = json['senderUsername'];
    reportedUsername = json['reportedUsername'];
    senderUId = json['senderUId'];
    reportedUId = json['reportedUId'];
    dateReport = json['dateReport'];
  }

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'senderUsername': senderUsername,
      'reportedUsername': reportedUsername,
      'senderUId': senderUId,
      'reportedUId': reportedUId,
      'dateReport': dateReport,
    };
  }
}
