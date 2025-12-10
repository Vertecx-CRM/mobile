import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vertecx/data/models/products/product_model.dart';

class ProductsService {
  final String baseUrl = "http://192.168.1.9:3001";
  final http.Client _client;

  ProductsService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<ProductModel>> getProducts({String status = 'all', String? token}) async {
    final uri = Uri.parse("$baseUrl/products").replace(
      queryParameters: {'status': status},
    );

    http.Response response;

    try {
      response = await _client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 25));
    } on SocketException {
      throw Exception('Sin conexión. Verifica red/IP del backend.');
    } catch (e) {
      throw Exception('Error de red: $e');
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener productos: ${response.statusCode}. Body: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception('Respuesta inválida del backend (se esperaba lista).');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
  }
}
