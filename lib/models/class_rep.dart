// lib/models/class_rep.dart
class ClassRep {
  final String id;
  final String name;
  final String code;
  final String? assignedDevice;
  final String? phone;

  ClassRep({
    required this.id,
    required this.name,
    required this.code,
    this.assignedDevice,
    this.phone,
  });

  factory ClassRep.fromMap(String id, Map<String, dynamic> m) {
    return ClassRep(
      id: id,
      name: m['name'] ?? '',
      code: m['code'] ?? '',
      assignedDevice: m['assignedDevice'],
      phone: m['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'assignedDevice': assignedDevice,
      'phone': phone,
    };
  }
}
