import 'package:flutter/material.dart';
import 'package:vertecx/data/models/request_model.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.data, this.onTap});
  final RequestModel data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Id:${data.id}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.estadoBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.estadoLabel,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: data.estadoFg),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(data.titulo, maxLines: 2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
            const SizedBox(height: 6),
            _meta('Tipo:', data.tipo),
            const SizedBox(height: 2),
            _meta('Fecha creación:', _fmt(data.fecha)),
          ],
        ),
      ),
    );
  }

  Widget _meta(String label, String value) {
    return RichText(
      text: TextSpan(
        text: '$label  ',
        style: const TextStyle(fontSize: 11, color: Colors.black54),
        children: [TextSpan(text: value, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600))],
      ),
    );
  }

  String _fmt(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd/$mm/$yy';
  }
}
