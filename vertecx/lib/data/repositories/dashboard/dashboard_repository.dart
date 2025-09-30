// dashboard_repository.dart
import 'dart:math';
import '../../models/dashboard/dashboard_models.dart';

class SalesRepository {
  Future<List<Sales>> fetchSales() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Sales(month: 1, amount: 800000),
      Sales(month: 2, amount: 1200000),
      Sales(month: 3, amount: 1300000),
      Sales(month: 4, amount: 1100000),
      Sales(month: 5, amount: 1250000),
      Sales(month: 6, amount: 2000000),
      Sales(month: 7, amount: 1000000),
      Sales(month: 8, amount: 1800000),
      Sales(month: 9, amount: 600000),
      Sales(month: 10, amount: 900000),
      Sales(month: 11, amount: 950000),
      Sales(month: 12, amount: 1100000),
    ];
  }

  Future<List<double>> fetchDailySales(int month) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final random = Random();
    return List.generate(31, (i) => 200 + random.nextInt(1000)).map((e) => e.toDouble()).toList();
  }
}

class ClientsRepository {
  Future<List<Clients>> fetchClients() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Clients(month: 1, amount: 800000),
      Clients(month: 2, amount: 1200000),
      Clients(month: 3, amount: 1300000),
      Clients(month: 4, amount: 1100000),
      Clients(month: 5, amount: 1250000),
      Clients(month: 6, amount: 2000000),
      Clients(month: 7, amount: 1000000),
      Clients(month: 8, amount: 1800000),
      Clients(month: 9, amount: 600000),
      Clients(month: 10, amount: 900000),
      Clients(month: 11, amount: 950000),
      Clients(month: 12, amount: 1100000),
    ];
  }

  Future<List<double>> fetchDailyClients(int month) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final random = Random();
    return List.generate(31, (i) => 200 + random.nextInt(1000)).map((e) => e.toDouble()).toList();
  }
}

class PurchasesRepository {
  Future<List<Sales>> fetchPurchases() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Sales(month: 1, amount: 500000),
      Sales(month: 2, amount: 700000),
      Sales(month: 3, amount: 650000),
      Sales(month: 4, amount: 800000),
      Sales(month: 5, amount: 900000),
      Sales(month: 6, amount: 1200000),
      Sales(month: 7, amount: 1100000),
      Sales(month: 8, amount: 950000),
      Sales(month: 9, amount: 600000),
      Sales(month: 10, amount: 850000),
      Sales(month: 11, amount: 1000000),
      Sales(month: 12, amount: 1050000),
    ];
  }

  Future<List<double>> fetchDailyPurchases(int month) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final random = Random();
    return List.generate(31, (i) => 300 + random.nextInt(800))
        .map((e) => e.toDouble())
        .toList();
  }
}

class AppointmentsRepository {
  Future<Map<String, int>> fetchAppointmentsStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "completadas": 30,
      "pendientes": 50,
      "enProgreso": 40,
      "anuladas": 20,
    };
  }
}

class OrdersRepository {
  Future<Map<String, int>> fetchOrdersStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "completadas": 45,
      "pendientes": 20,
      "enProceso": 25,
      "canceladas": 10,
    };
  }
}

class ProductsRepository {
  Future<Map<String, double>> fetchProductsByCategory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "Computadores": 10,
      "Servidores": 10,
      "Camaras": 10,
      "Cableado": 10,
      "Paneles solares": 10,
      "Baterias": 40,
    };
  }
}




