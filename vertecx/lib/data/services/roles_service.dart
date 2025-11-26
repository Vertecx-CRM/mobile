import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'package:vertecx/data/models/roles/role_model.dart';  

class RolesService {
  final String baseUrl = "http://192.168.1.9:3001";

  Future<List<RoleModel>> getRoles() async {
    final uri = Uri.parse('$baseUrl/roles/list');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);

      final List<dynamic> data = jsonBody['data'] as List<dynamic>;

      return data
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Error al obtener roles: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }
}
