enum RoleStatus { activo, inactivo }

class RoleModel {
  final int id;
  final String name;
  final RoleStatus status;

  RoleModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    final raw = (json['status'] ?? '').toString().toLowerCase();

    return RoleModel(
      id: json['roleid'] ?? 0,
      name: json['name'] ?? '',
      status: (raw == 'active' || raw == 'activo')
          ? RoleStatus.activo
          : RoleStatus.inactivo,
    );
  }
}
