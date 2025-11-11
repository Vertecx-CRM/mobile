import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:vertecx/data/models/request/request_model.dart';

class ServiceRequestsService {
  final String baseUrl;
  const ServiceRequestsService({required this.baseUrl});

  Uri _uri(String path, [Map<String, dynamic>? q]) {
    final uri = Uri.parse('$baseUrl$path');
    return q == null ? uri : uri.replace(queryParameters: q);
  }

  Future<List<ServiceRequestModel>> getRequests({int page = 1, int limit = 50}) async {
    final url = _uri('/service-requests', {'page': '$page', 'limit': '$limit'});
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
      return data
          .whereType<Map<String, dynamic>>()
          .map(ServiceRequestModel.fromJson)
          .toList();
    } on TimeoutException {
      throw Exception('GET ${url.path}: timeout');
    } catch (e) {
      rethrow;
    }
  }
}
