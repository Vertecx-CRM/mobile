enum UserStatus { activo, inactivo }

// Enum para manejar el rol del usuario de forma segura
enum UserRole { administrador, cliente, tecnico }

class UserModel {
  final String id;
  final String nombreCompleto;
  final String documentoId;
  final String telefono;
  final String email;
  final UserStatus estado;
  final UserRole rol;
  final String imagenPath;

  UserModel({
    required this.id,
    required this.nombreCompleto,
    required this.documentoId,
    required this.telefono,
    required this.email,
    required this.estado,
    required this.rol,
    required this.imagenPath
  });

  // Método de utilidad para mapear el enum a una cadena legible
  String get roleString {
    switch (rol) {
      case UserRole.administrador:
        return "Administrador";
      case UserRole.cliente:
        return "Cliente";
      case UserRole.tecnico:
        return "Técnico";
    }
  }

  // Método de utilidad para mapear el enum a una cadena de estado legible
  String get statusString {
    return estado == UserStatus.activo ? "Activo" : "Inactivo";
  }
}

UserModel toggleStatus(UserModel user) {
  return UserModel(
    id: user.id,
    nombreCompleto: user.nombreCompleto,
    documentoId: user.documentoId,
    telefono: user.telefono,
    email: user.email,
    estado: user.estado == UserStatus.activo
        ? UserStatus.inactivo
        : UserStatus.activo,
    rol: user.rol,
    imagenPath: user.imagenPath
  );
}

extension UserSearch on UserModel {
  bool matchesQuery(String query) {
    final normalizedQuery = removeDiacritics(query.toLowerCase());

    //chequeo exacto para estados
    if (normalizedQuery == "activo") {
      return estado == UserStatus.activo;
    }
    if (normalizedQuery == "inactivo") {
      return estado == UserStatus.inactivo;
    }

    //resto de campos usa búsqueda flexible con contains
    return removeDiacritics(nombreCompleto.toLowerCase()).contains(normalizedQuery) ||
           removeDiacritics(documentoId.toLowerCase()).contains(normalizedQuery) ||
           removeDiacritics(telefono.toLowerCase()).contains(normalizedQuery) ||
           removeDiacritics(email.toLowerCase()).contains(normalizedQuery) ||
           removeDiacritics(roleString.toLowerCase()).contains(normalizedQuery) ||
           removeDiacritics(statusString.toLowerCase()).contains(normalizedQuery);
  }
}

String removeDiacritics(String input) {
  const withDiacritics = 'áéíóúÁÉÍÓÚñÑ';
  const withoutDiacritics = 'aeiouAEIOUnN';

  return input.split('').map((char) {
    final index = withDiacritics.indexOf(char);
    if (index >= 0) {
      return withoutDiacritics[index];
    }
    return char;
  }).join();
}

