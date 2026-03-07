import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

class StudentService {
  final CollectionReference studentsRef =
      FirebaseFirestore.instance.collection("students");

  // Get student by RFID tag
  Future<Student?> getByRfid(String rfid) async {
    final query =
        await studentsRef.where("rfidTag", isEqualTo: rfid).limit(1).get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;
    return Student.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  // Add student
  Future<void> add(Student student) async {
    await studentsRef.doc(student.id).set(student.toJson());
  }

  // Update student
  Future<void> update(Student student) async {
    await studentsRef.doc(student.id).update(student.toJson());
  }

  // Delete student
  Future<void> delete(String id) async {
    await studentsRef.doc(id).delete();
  }

  // Stream all students
  Stream<List<Student>> getAll() {
    return studentsRef.snapshots().map((snap) {
      return snap.docs.map((e) {
        return Student.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
    });
  }
}
