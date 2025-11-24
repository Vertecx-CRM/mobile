enum TechnicianStatus { activo, inactivo }

class TechnicianModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final TechnicianStatus status;
  final String? image;
  final List<String> types;

  TechnicianModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    required this.types,
    this.image,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    final user = json['users'] ?? {};
    final state = user['states'] ?? {};

    return TechnicianModel(
      id: json['technicianid'] ?? 0,

      name: "${user['name'] ?? ''} ${user['lastname'] ?? ''}",

      phone: user['phone'] ?? '',

      email: user['email'] ?? '',

      image: user['image'],

      status: (state['name']?.toString().toLowerCase() == 'activo')
          ? TechnicianStatus.activo
          : TechnicianStatus.inactivo,

      types: (json['technicianTypeMaps'] as List? ?? [])
          .map((t) =>
              t['techniciantype']?['name']?.toString() ?? "")
          .toList(),
    );
  }
}
