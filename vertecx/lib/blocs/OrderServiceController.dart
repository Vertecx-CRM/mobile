import 'package:flutter/foundation.dart';
import 'package:vertecx/data/models/order_service_models.dart';
import 'package:vertecx/data/repositories/order_repository.dart';


class OrderServiceController extends ChangeNotifier {
  OrderServiceController(this._repo);

  final OrderRepository _repo;

  List<OrderService> _all = [];
  List<OrderService> _visible = [];
  String _query = '';

  List<OrderService> get orders => _visible;

  Future<void> load() async {
    _all = await _repo.getAll();
    _applyFilter();
  }

  void search(String q) {
    _query = q;
    _applyFilter();
  }

  void _applyFilter() {
    if (_query.trim().isEmpty) {
      _visible = List.of(_all);
    } else {
      final q = _query.toLowerCase();
      _visible = _all.where((o) {
        return o.titulo.toLowerCase().contains(q) ||
            o.tecnico.toLowerCase().contains(q) ||
            'id:${o.id}'.contains(q);
      }).toList();
    }
    notifyListeners();
  }
}
