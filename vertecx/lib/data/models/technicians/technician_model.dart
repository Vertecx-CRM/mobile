enum TechnicianStatus { activo, inactivo }

class TechnicianModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final TechnicianStatus status;
  final String? imagePath;
  TechnicianModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    this.imagePath,
  });

  // Método de utilidad para mostrar el estado como texto
  String get statusString =>
      status == TechnicianStatus.activo ? "Activo" : "Inactivo";

  // Método para cambiar el estado
  TechnicianModel toggleStatus() {
    return TechnicianModel(
      id: id,
      name: name,
      phone: phone,
      email: email,
      status: status == TechnicianStatus.activo
          ? TechnicianStatus.inactivo
          : TechnicianStatus.activo,
      imagePath: imagePath,
    );
  }
}
