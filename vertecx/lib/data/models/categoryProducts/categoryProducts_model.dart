enum CategoryStatus { activo, inactivo }

class CategoryProduct {
  final int id;
  final String imagenPath;
  final String nombre;
  final String descripcion;
  final CategoryStatus estado;

  CategoryProduct({
    required this.id,
    required this.imagenPath,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  String get statusString =>
      estado == CategoryStatus.activo ? "Activo" : "Inactivo";
}

/// Alternar estado
CategoryProduct toggleCategoryStatus(CategoryProduct category) {
  return CategoryProduct(
    id: category.id,
    imagenPath: category.imagenPath,
    nombre: category.nombre,
    descripcion: category.descripcion,
    estado: category.estado == CategoryStatus.activo
        ? CategoryStatus.inactivo
        : CategoryStatus.activo,
  );
}

/// Lógica de búsqueda
extension CategorySearch on CategoryProduct {
  bool matchesQuery(String query) {
    final normalizedQuery = removeDiacritics(query.toLowerCase());

    if (normalizedQuery == "activo") {
      return estado == CategoryStatus.activo;
    }
    if (normalizedQuery == "inactivo") {
      return estado == CategoryStatus.inactivo;
    }

    return id.toString().contains(normalizedQuery) ||
        removeDiacritics(nombre.toLowerCase()).contains(normalizedQuery) ||
        removeDiacritics(statusString.toLowerCase()).contains(normalizedQuery);
  }
}

/// Función utilitaria para quitar tildes
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
