import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String fullName;
  final String rfidTag;
  final String programme;
  final int level;
  final String indexNumber;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.fullName,
    required this.rfidTag,
    required this.programme,
    required this.level,
    required this.indexNumber,
    required this.createdAt,
  });

  factory Student.fromJson(Map<String, dynamic> json, String id) {
    return Student(
      id: id,
      fullName: json['fullName'],
      rfidTag: json['rfidTag'],
      programme: json['programme'],
      level: json['level'],
      indexNumber: json['indexNumber'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'rfidTag': rfidTag,
      'programme': programme,
      'level': level,
      'indexNumber': indexNumber,
      'createdAt': createdAt,
    };
  }
}
