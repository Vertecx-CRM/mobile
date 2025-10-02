import 'dart:ui';

enum SaleStatus { finalizado, anulado }

class SaleModel {
  final String id; // Ej: Ven-001
  final String clientName;
  final DateTime date;
  final double total;
  final SaleStatus status;

  SaleModel({
    required this.id,
    required this.clientName,
    required this.date,
    required this.total,
    required this.status,
  });

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
