import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/users/user_model.dart';

class UserService {
  final String baseUrl = "http://192.168.1.9:3001";

  Future<List<UserModel>> getUsers() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(url);

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

      return payload.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener usuarios: ${response.statusCode}');
    }
  }

  Future<UserModel> updateUserStatus(String userId, bool newStatus) async {
    final stateId = newStatus ? 1 : 2;

    final url = Uri.parse('$baseUrl/users/$userId');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'stateid': stateId}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final updated = jsonData['data'];
      return UserModel.fromJson(updated);
    } else {
      throw Exception('Error al actualizar estado: ${response.statusCode} - ${response.body}');
    }
  }
}
