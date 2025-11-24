import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vertecx/data/models/technicians/technician_model.dart';

class TechniciansService {
  final String baseUrl = "http://192.168.1.54:3001";

  Future<List<TechnicianModel>> getTechnicians() async {
    final uri = Uri.parse("$baseUrl/technicians");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => TechnicianModel.fromJson(e))
          .toList();
    } else {
      throw Exception(
        "Error al obtener técnicos: ${response.statusCode} ${response.reasonPhrase}",
      );
    }
  }
}
