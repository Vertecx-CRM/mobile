import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vertecx/data/models/technicians/technician_model.dart';

class TechniciansService {
  final String baseUrl = "http://192.168.1.9:3001";

  final http.Client _client;

  TechniciansService({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<TechnicianModel>> getTechnicians({String? token}) async {
    final uri = Uri.parse("$baseUrl/technicians");

    http.Response response;

    try {
      response = await _client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              if (token != null && token.isNotEmpty)
                'Authorization': 'Bearer $token',
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
        "Error al obtener técnicos: "
        "${response.statusCode}. Body: ${response.body}",
      );
    }

    final decoded = jsonDecode(response.body);

    // Soporta tanto [ {...}, {...} ] como { data: [ ... ] }
    List<dynamic> list;
    if (decoded is List) {
      list = decoded;
    } else if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      list = decoded['data'] as List;
    } else {
      list = const [];
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map(TechnicianModel.fromJson)
        .toList();
  }
}
