import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sales/sale_model.dart';

class SaleService {
  final String baseUrl = "http://192.168.1.9:3001";

  Future<List<SaleModel>> getSales() async {
    final url = Uri.parse('$baseUrl/sales');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => SaleModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener ventas: ${response.statusCode}');
    }
  }
}