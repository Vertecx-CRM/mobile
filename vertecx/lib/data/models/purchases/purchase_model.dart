import 'dart:ui';

enum PurchaseStatus { Approved, revoke }

class PurchaseModel {
  final String id;
  final String factura;
  final String proveedor;
  final DateTime fecha;
  final double total;
  final PurchaseStatus estado;

  PurchaseModel({
    required this.id,
    required this.factura,
    required this.proveedor,
    required this.fecha,
    required this.total,
    required this.estado,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    // Obtener el estado desde statusid
    final statusId = json['statusid'] as int;
    final estado =
        statusId == 1 ? PurchaseStatus.Approved : PurchaseStatus.revoke;

    return PurchaseModel(
      id: json['purchaseid'].toString(),
      factura: json['invoice'] ?? 'Sin factura',
      proveedor: json['supplier']['name'] ?? 'Proveedor desconocido',
      fecha: DateTime.parse(json['date']),
      total: (json['total'] as num).toDouble(),
      estado: estado,
    );
  }

  // 🔹 Texto del estado
  String get estadoTexto =>
      estado == PurchaseStatus.Approved ? "Approved" : "revoke";

  // 🔹 Color de fondo del estado
  Color get estadoColorFondo => estado == PurchaseStatus.Approved
      ? const Color(0xFFD2F5D3)
      : const Color(0xFFF5D2D2);

  // 🔹 Color del texto del estado
  Color get estadoColorTexto => estado == PurchaseStatus.Approved
      ? const Color(0xFF168700)
      : const Color(0xFF870000);

  // 🔹 Formato del precio
  String get precioFormateado {
    return "\$${total.toStringAsFixed(2)}";
  }

  // 🔹 Formato de fecha (yyyy-MM-dd)
  String get fechaFormateada {
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }
}

PurchaseModel toggleStatus(PurchaseModel purchase) {
  final newStatus = purchase.estado == PurchaseStatus.Approved
      ? PurchaseStatus.revoke
      : PurchaseStatus.Approved;

  return PurchaseModel(
    id: purchase.id,
    factura: purchase.factura,
    proveedor: purchase.proveedor,
    fecha: purchase.fecha,
    total: purchase.total,
    estado: newStatus,
  );
}
