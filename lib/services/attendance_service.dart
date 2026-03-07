import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_session_model.dart';
import '../models/attendance_record_model.dart';

class AttendanceService {
  final sessionsRef =
      FirebaseFirestore.instance.collection("attendanceSessions");

  // Start a session
  Future<String> startSession(AttendanceSession session) async {
    final doc = sessionsRef.doc(); // auto ID
    await doc.set(session.toJson());
    return doc.id;
  }

  // End a session
  Future<void> endSession(String sessionId) async {
    await sessionsRef.doc(sessionId).update({
      "endTime": DateTime.now(),
      "status": "completed",
    });
  }

  // Add attendance record
  Future<void> addRecord(String sessionId, AttendanceRecord record) async {
    final recordsRef = sessionsRef.doc(sessionId).collection("records");

    await recordsRef.add(record.toJson());
  }

  // Get attendance records for a session
  Stream<List<AttendanceRecord>> getRecords(String sessionId) {
    return sessionsRef
        .doc(sessionId)
        .collection("records")
        .orderBy("timestamp")
        .snapshots()
        .map((snap) => snap.docs.map((e) {
              return AttendanceRecord.fromJson(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  // Get all sessions
  Stream<List<AttendanceSession>> getAllSessions() {
    return sessionsRef.snapshots().map((snap) {
      return snap.docs.map((e) {
        return AttendanceSession.fromJson(
            e.data() as Map<String, dynamic>, e.id);
      }).toList();
    });
  }
}
