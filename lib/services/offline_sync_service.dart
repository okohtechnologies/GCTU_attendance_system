import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offline_record_model.dart';

class OfflineSyncService {
  final queueRef = FirebaseFirestore.instance.collection("offlineQueues");

  // Add offline record from a device
  Future<void> addRecord(String deviceId, OfflineRecord record) async {
    await queueRef.doc(deviceId).set({
      "pendingUploads": FieldValue.arrayUnion([record.toJson()])
    }, SetOptions(merge: true));
  }

  // Get queue for a device
  Future<List<OfflineRecord>> getQueue(String deviceId) async {
    final doc = await queueRef.doc(deviceId).get();
    if (!doc.exists) return [];

    List data = doc.data()!["pendingUploads"] ?? [];
    return data.map((e) => OfflineRecord.fromJson(e)).toList();
  }

  // Clear queue after successful sync
  Future<void> clearQueue(String deviceId) async {
    await queueRef.doc(deviceId).update({"pendingUploads": []});
  }
}
