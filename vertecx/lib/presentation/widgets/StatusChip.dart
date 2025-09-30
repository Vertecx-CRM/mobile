import 'package:flutter/material.dart';
import 'package:vertecx/data/models/OrderService.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final OrderServiceStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = _map(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  (String, Color, Color) _map(OrderServiceStatus s) {
    switch (s) {
      case OrderServiceStatus.completada:
        return ('Completada', Colors.green.shade700, Colors.green.shade100);
      case OrderServiceStatus.pendiente:
        return ('Pendiente', Colors.orange.shade800, Colors.orange.shade100);
      case OrderServiceStatus.anulada:
        return ('Anulada', Colors.red.shade700, Colors.red.shade100);
      case OrderServiceStatus.enProgreso:
        return ('En progreso', Colors.blue.shade700, Colors.blue.shade100);
    }
  }
}
