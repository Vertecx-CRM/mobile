import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  DashboardService({String? baseUrl})
      : baseUrl = baseUrl ?? 'http://192.168.1.9:3001';

  final String baseUrl;
  String get _dashboardBase => '$baseUrl/dashboard';

  Future<List<dynamic>> fetchSalesByYear() => _getList('$_dashboardBase/sales/year');
  Future<Map<String, dynamic>> fetchTotalSales() => _getMap('$_dashboardBase/sales/total');
  Future<List<dynamic>> fetchDailySales(int month) => _getList('$_dashboardBase/sales/month/$month');

  Future<List<dynamic>> fetchPurchasesByYear() => _getList('$_dashboardBase/purchases/year');
  Future<Map<String, dynamic>> fetchTotalPurchases() => _getMap('$_dashboardBase/purchases/total');
  Future<List<dynamic>> fetchDailyPurchases(int month) => _getList('$_dashboardBase/purchases/month/$month');

  Future<List<dynamic>> fetchClientsByYear() => _getList('$_dashboardBase/clients/year');
  Future<Map<String, dynamic>> fetchTotalClients() => _getMap('$_dashboardBase/clients/total');
  Future<List<dynamic>> fetchDailyClients(int month) => _getList('$_dashboardBase/clients/month/$month');

  Future<List<dynamic>> fetchProductsByCategory() => _getList('$_dashboardBase/categories/products');

  Future<List<dynamic>> fetchOrdersByState() => _getList('$_dashboardBase/orders/state');
  Future<Map<String, dynamic>> fetchTotalOrders() => _getMap('$_dashboardBase/orders/total');

  Future<List<dynamic>> fetchServiceRequestsByState() => _getList('$_dashboardBase/service-requests/state');
  Future<Map<String, dynamic>> fetchTotalServiceRequests() => _getMap('$_dashboardBase/service-requests/total');

  Future<dynamic> _get(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Error ${response.statusCode} al consultar ${uri.path}: ${response.body}',
    );
  }

  Future<List<dynamic>> _getList(String url) async {
    final decoded = await _get(url);

    if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      return List<dynamic>.from(decoded['data'] as List);
    }
    if (decoded is List) {
      return List<dynamic>.from(decoded);
    }

    throw Exception('Formato inesperado de respuesta en $url');
  }

  Future<Map<String, dynamic>> _getMap(String url) async {
    final decoded = await _get(url);

    if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(decoded['data'] as Map);
      }
      return Map<String, dynamic>.from(decoded);
    }

    throw Exception('Formato inesperado de respuesta en $url');
  }
}
