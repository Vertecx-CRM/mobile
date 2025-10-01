enum RoleStatus { activo, inactivo }

class RoleModel {
  final String id;
  final String name;
  final RoleStatus status;
  RoleModel({required this.id, required this.name, required this.status});

  // Método de utilidad para mostrar el estado como texto
  String get statusString =>
      status == RoleStatus.activo ? "Activo" : "Inactivo";

  // Método para cambiar el estado
  RoleModel toggleStatus() {
    return RoleModel(
      id: id,
      name: name,
      status: status == RoleStatus.activo
          ? RoleStatus.inactivo
          : RoleStatus.activo,
    );
  }
}
