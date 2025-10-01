import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vertecx/data/models/order_service_models.dart';
import 'package:vertecx/presentation/widgets/StatusChip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onTap});

  final OrderService order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 0,
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Id:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('${order.id}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  StatusChip(status: order.estado),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                order.titulo,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text('Técnico: ${order.tecnico}', style: TextStyle(color: Colors.grey.shade700)),
              Text('Fecha creación: ${f.format(order.fechaCreacion)}',
                  style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        ),
      ),
    );
  }
}