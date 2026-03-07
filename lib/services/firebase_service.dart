// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_rep.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lookup class rep by code (case-insensitive)
  Future<ClassRep?> getClassRepByCode(String code) async {
    final q = await _db
        .collection('class_reps')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if (q.docs.isEmpty) return null;
    final doc = q.docs.first;
    return ClassRep.fromMap(doc.id, doc.data());
  }

  Future<void> updateLastLogin(String repId) async {
    await _db.collection('class_reps').doc(repId).update({
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }
}
