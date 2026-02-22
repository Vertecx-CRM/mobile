import 'dart:convert';
import 'package:vertecx/core/api_http.dart';
import 'package:vertecx/data/models/categoryProducts/categoryProducts_model.dart';

class CategoryProductsService {
  final String baseUrl = "http://192.168.1.9:3001";

  Future<List<CategoryProduct>> getCategories() async {
    final url = Uri.parse('$baseUrl/products-categories');
    final response = await ApiHttp.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> payload;
      if (jsonData is List) {
        payload = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        payload = List<dynamic>.from(jsonData['data'] ?? []);
      } else {
        payload = [];
      }

      return payload.map((e) => CategoryProduct.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener categorヴas: ${response.statusCode}');
    }
  }

  Future<void> createCategory(CategoryProduct category) async {
    final url = Uri.parse('$baseUrl/products-categories');
    final response = await ApiHttp.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": category.nombre,
        "description": category.descripcion,
        "status": category.estado == CategoryStatus.activo,
        "icon": category.imagenPath,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear categorヴa');
    }
  }

  Future<CategoryProduct> updateStatus(int id, bool newStatus) async {
    final url = Uri.parse('$baseUrl/products-categories/$id');
    final body = jsonEncode({'status': newStatus});
    final response = await ApiHttp.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final updated = jsonData['data'];
      return CategoryProduct.fromJson(updated);
    } else {
      throw Exception(
        'Error al actualizar estado: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
