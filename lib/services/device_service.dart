import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';

class DeviceService {
  final CollectionReference devicesRef =
      FirebaseFirestore.instance.collection("devices");

  // Register device
  Future<void> register(DeviceModel device) async {
    await devicesRef.doc(device.deviceId).set(device.toJson());
  }

  // Get device
  Future<DeviceModel?> getDevice(String deviceId) async {
    final doc = await devicesRef.doc(deviceId).get();

    if (!doc.exists) return null;

    return DeviceModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  // Update lastSync
  Future<void> updateLastSync(String deviceId) async {
    await devicesRef.doc(deviceId).update({
      "lastSync": DateTime.now(),
      "status": "online",
    });
  }

  // Stream all devices
  Stream<List<DeviceModel>> getAll() {
    return devicesRef.snapshots().map((snap) {
      return snap.docs.map((e) {
        return DeviceModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
