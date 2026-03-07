import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_rep.dart';

class ClassRepService {
  final CollectionReference repsRef =
      FirebaseFirestore.instance.collection("classReps");

  // Get class rep using unique login code
  Future<ClassRep?> getByCode(String code) async {
    final query = await repsRef.where("uniqueCode", isEqualTo: code).get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;
    return ClassRep.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  // Create class rep
  Future<void> create(ClassRep rep) async {
    await repsRef.doc(rep.id).set(rep.toMap());
  }

  // Get all class reps
  Stream<List<ClassRep>> getAll() {
    return repsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((e) {
        return ClassRep.fromMap(e.id, e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Delete class rep
  Future<void> delete(String id) async {
    await repsRef.doc(id).delete();
  }
}
