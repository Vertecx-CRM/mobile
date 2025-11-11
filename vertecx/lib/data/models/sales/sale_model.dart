import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:vertecx/data/models/sales/sale_item_model.dart';

enum SaleStatus { finalizado, anulado }

class SaleModel {
  final String id;
  final String clientName;
  final DateTime date;
  final double subtotal;
  final double iva;
  final double discount;
  final double total;
  final SaleStatus status;
  final List<SaleItemModel> items;
  SaleModel({
    required this.id,
    required this.clientName,
    required this.date,
    required this.subtotal,
    required this.iva,
    required this.discount,
    required this.total,
    required this.status,
    required this.items,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    // Obtener el estado desde stateid
    final stateId = json['stateid'] as int;
    final status = stateId == 1 ? SaleStatus.finalizado : SaleStatus.anulado;

    // Parsear la lista de items
    List<SaleItemModel> items = [];
    try {
      final itemsJson = json['saleitems'] as List<dynamic>;
      items = itemsJson
          .map((itemJson) => SaleItemModel.fromJson(itemJson))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error al parsear items de venta: $e");
      }
    }

    return SaleModel(
      id: json['saleid'].toString(),
      clientName: json['clientname'] ?? 'Cliente sin nombre',
      date: DateTime.parse(json['date']),
      subtotal: (json['subtotal'] as num).toDouble(),
      iva: (json['iva'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: status,
      items: items,
    );
  }

  // Texto del estado
  String get statusString =>
      status == SaleStatus.finalizado ? "Finalizado" : "Anulado";

  // Color de estado
  get statusColor => status == SaleStatus.finalizado
      ? const Color(0xFF168700)
      : const Color(0xFF870000);

  // Formatear precio
  String get formattedPrice {
    return "\$${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
  }

  // Fecha en dd/MM/yyyy
  String get formattedDate =>
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}
