import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class OrderServicesService {
  final String baseUrl;

  const OrderServicesService({required this.baseUrl});

  Uri _uri(String path, [Map<String, dynamic>? q]) {
    final uri = Uri.parse('$baseUrl$path');
    return q == null ? uri : uri.replace(queryParameters: q);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final url = _uri('/orders-services');
    try {
      final res = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) {
        throw Exception('GET ${url.path}: ${res.statusCode} - ${res.body}');
      }

      final body = jsonDecode(res.body);
      final List data = body is Map<String, dynamic>
          ? (body['data'] is List ? body['data'] as List : [])
          : (body is List ? body : []);

      return data.whereType<Map<String, dynamic>>().toList();
    } on TimeoutException {
      throw Exception('GET ${url.path}: timeout');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getOrderById(int id) async {
    final url = _uri('/orders-services/$id');
    try {
      final res = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) {
        throw Exception('GET ${url.path}: ${res.statusCode} - ${res.body}');
      }

      final body = jsonDecode(res.body);
      if (body is Map<String, dynamic>) {
        return body;
      }
      throw Exception('GET ${url.path}: respuesta inesperada');
    } on TimeoutException {
      throw Exception('GET ${url.path}: timeout');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getOrderHistory(int id) async {
    final url = _uri('/orders-services/$id/history');
    try {
      final res = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) {
        throw Exception('GET ${url.path}: ${res.statusCode} - ${res.body}');
      }

      final body = jsonDecode(res.body);
      final List data = body is Map<String, dynamic>
          ? (body['data'] is List
                ? body['data'] as List
                : (body['history'] is List ? body['history'] as List : []))
          : (body is List ? body : []);

      return data.whereType<Map<String, dynamic>>().toList();
    } on TimeoutException {
      throw Exception('GET ${url.path}: timeout');
    } catch (e) {
      rethrow;
    }
  }
}
