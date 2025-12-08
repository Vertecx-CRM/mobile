import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vertecx/data/models/services/service_model.dart';

class ServicesService {
  final String baseUrl = "http://192.168.1.54:3001";
  final http.Client _client;

  ServicesService({http.Client? client}) : _client = client ?? http.Client();

  Future<_ServicesPageResponse> getServices({
    int page = 1,
    int limit = 50,
    String? token,
  }) async {
    final qp = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse("$baseUrl/services").replace(queryParameters: qp);

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
          .timeout(const Duration(seconds: 25));
    } on SocketException {
      throw Exception('Sin conexión. Verifica red/IP del backend.');
    } catch (e) {
      throw Exception('Error de red: $e');
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener servicios: ${response.statusCode}. Body: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Respuesta inválida del backend (se esperaba objeto).');
    }

    final rawData = decoded['data'];
    final rawMeta = decoded['meta'];

    final List<ServiceModel> services = (rawData is List)
        ? rawData
            .whereType<Map<String, dynamic>>()
            .map(ServiceModel.fromJson)
            .toList()
        : <ServiceModel>[];

    final meta = ServicesMeta.fromJson(
      rawMeta is Map<String, dynamic> ? rawMeta : <String, dynamic>{},
    );

    return _ServicesPageResponse(data: services, meta: meta);
  }
}

class ServicesMeta {
  final int page;
  final int limit;
  final int total;
  final int pages;

  ServicesMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  static int _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  factory ServicesMeta.fromJson(Map<String, dynamic> json) {
    return ServicesMeta(
      page: _asInt(json['page']) == 0 ? 1 : _asInt(json['page']),
      limit: _asInt(json['limit']) == 0 ? 50 : _asInt(json['limit']),
      total: _asInt(json['total']),
      pages: _asInt(json['pages']) == 0 ? 1 : _asInt(json['pages']),
    );
  }
}

class _ServicesPageResponse {
  final List<ServiceModel> data;
  final ServicesMeta meta;

  _ServicesPageResponse({required this.data, required this.meta});
}
