import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vertecx/data/models/roles/role_model.dart';

class RolesService {
  final String baseUrl = "http://192.168.1.9:3001";

  Future<List<RoleModel>> getRoles({String? token}) async {
    final uri = Uri.parse('$baseUrl/roles/list');

    http.Response response;

    try {
      response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));
    } on SocketException {
      throw Exception('Sin conexión. Verifica red/IP del backend.');
    } catch (e) {
      throw Exception('Error de red: $e');
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener roles: ${response.statusCode}. Body: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    final data = (decoded is Map<String, dynamic>) ? decoded['data'] : null;
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(RoleModel.fromJson)
        .toList();
  }
}
