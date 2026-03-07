class OfflineRecord {
  final String rfidTag;
  final String studentId;
  final int timestamp;
  final String courseCode;

  OfflineRecord({
    required this.rfidTag,
    required this.studentId,
    required this.timestamp,
    required this.courseCode,
  });

  factory OfflineRecord.fromJson(Map<String, dynamic> json) {
    return OfflineRecord(
      rfidTag: json['rfidTag'],
      studentId: json['studentId'],
      timestamp: json['timestamp'],
      courseCode: json['courseCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rfidTag': rfidTag,
      'studentId': studentId,
      'timestamp': timestamp,
      'courseCode': courseCode,
    };
  }
}
