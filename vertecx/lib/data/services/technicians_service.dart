import 'dart:convert';
import 'dart:io';
import 'package:vertecx/core/api_http.dart';
import 'package:vertecx/core/session_context.dart';
import 'package:vertecx/data/models/technicians/technician_model.dart';

class TechniciansService {
  final String baseUrl = "http://192.168.1.9:3001";

  Future<List<TechnicianModel>> getTechnicians({String? token}) async {
    final uri = Uri.parse("$baseUrl/technicians");
    final effectiveToken = token ?? SessionContext.accessToken;

    try {
      final response = await ApiHttp.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (effectiveToken != null && effectiveToken.isNotEmpty)
            'Authorization': 'Bearer $effectiveToken',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          "Error al obtener tÃ©cnicos: "
          "${response.statusCode}. Body: ${response.body}",
        );
      }

      final decoded = jsonDecode(response.body);
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
    } on SocketException {
      throw Exception('Sin conexiÃ³n. Verifica red/IP del backend.');
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }
}
