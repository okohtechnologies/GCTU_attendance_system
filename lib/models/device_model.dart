import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String deviceId;
  final String name;
  final String assignedTo;
  final String location;
  final List<String> supports;
  final String status;
  final DateTime? lastSync;

  DeviceModel({
    required this.deviceId,
    required this.name,
    required this.assignedTo,
    required this.location,
    required this.supports,
    required this.status,
    this.lastSync,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['deviceId'],
      name: json['name'],
      assignedTo: json['assignedTo'],
      location: json['location'],
      supports: List<String>.from(json['supports']),
      status: json['status'],
      lastSync: json['lastSync'] != null
          ? (json['lastSync'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'name': name,
      'assignedTo': assignedTo,
      'location': location,
      'supports': supports,
      'status': status,
      'lastSync': lastSync,
    };
  }
}
