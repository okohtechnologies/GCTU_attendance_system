import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceSession {
  final String sessionId;
  final String courseCode;
  final String courseName;
  final String classRepCode;
  final String deviceId;
  final String date;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;

  AttendanceSession({
    required this.sessionId,
    required this.courseCode,
    required this.courseName,
    required this.classRepCode,
    required this.deviceId,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.status,
  });

  factory AttendanceSession.fromJson(Map<String, dynamic> json, String id) {
    return AttendanceSession(
      sessionId: id,
      courseCode: json['courseCode'],
      courseName: json['courseName'],
      classRepCode: json['classRepCode'],
      deviceId: json['deviceId'],
      date: json['date'],
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: json['endTime'] != null
          ? (json['endTime'] as Timestamp).toDate()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'classRepCode': classRepCode,
      'deviceId': deviceId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }
}
