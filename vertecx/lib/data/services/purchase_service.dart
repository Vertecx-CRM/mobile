import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/purchases/purchase_model.dart';

class PurchaseService {
  final String baseUrl = "http://192.168.1.9:3001";

  Future<List<PurchaseModel>> getPurchases() async {
    final url = Uri.parse('$baseUrl/purchases');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => PurchaseModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener compras: ${response.statusCode}');
    }
  }
}