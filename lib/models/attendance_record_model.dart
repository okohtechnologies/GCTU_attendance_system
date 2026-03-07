import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  final String id;
  final String studentId;
  final String rfidTag;
  final DateTime timestamp;
  final String status;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.rfidTag,
    required this.timestamp,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json, String id) {
    return AttendanceRecord(
      id: id,
      studentId: json['studentId'],
      rfidTag: json['rfidTag'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'rfidTag': rfidTag,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
