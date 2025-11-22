import 'package:flutter/material.dart';
import 'package:vertecx/data/models/request/request_model.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.data, this.onTap});
  final ServiceRequestModel data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final stateLabel = _stateLabel(data);
    final colors = _stateColors(stateLabel);

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
                Text('Id:${data.serviceRequestId}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.$1,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    stateLabel,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.$2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data.serviceType,
              maxLines: 2,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            _meta('Servicio:', _serviceName(data)),
            const SizedBox(height: 2),
            _meta('Cliente:', _customerName(data)),
            const SizedBox(height: 2),
            _meta('Fecha creación:', _fmt(data.createdAt)),
            if (data.scheduledAt != null) ...[
              const SizedBox(height: 2),
              _meta('Programada:', _fmt(data.scheduledAt!)),
            ],
          ],
        ),
      ),
    );
  }

  String _serviceName(ServiceRequestModel d) {
    final dynamic v = d.service?['name'] ?? d.service?['nombre'] ?? '';
    final s = v.toString().trim();
    return s.isEmpty ? 'Sin definir' : s;
  }

  String _customerName(ServiceRequestModel d) {
    final c = d.customer;
    if (c == null) return 'Sin definir';

    Map<String, dynamic>? asMap(dynamic v) => v is Map ? Map<String, dynamic>.from(v as Map) : null;

    final u = asMap(c['users']);
    final name = (u?['name'] ?? u?['firstname'] ?? u?['firstName'] ?? c['name'] ?? c['firstname'] ?? c['firstName'] ?? '').toString().trim();
    final last = (u?['lastname'] ?? u?['lastName'] ?? c['lastname'] ?? c['lastName'] ?? '').toString().trim();

    final full = [name, last].where((e) => e.isNotEmpty).join(' ').trim();
    return full.isEmpty ? 'Sin definir' : full;
  }

  String _stateLabel(ServiceRequestModel d) {
    final dynamic v = d.state?['name'] ?? d.state?['nombre'] ?? '';
    final s = v.toString().trim();
    return s.isEmpty ? 'Estado ${d.stateId}' : s;
  }

  (Color, Color) _stateColors(String label) {
    final l = label.toLowerCase();
    if (l.contains('pend')) return (const Color(0xFFFFF4DD), const Color(0xFF9B6A00));
    if (l.contains('proceso') || l.contains('en proc')) return (const Color(0xFFE6F0FF), const Color(0xFF0B57D0));
    if (l.contains('compl') || l.contains('final')) return (const Color(0xFFE9F7EC), const Color(0xFF2E7D32));
    if (l.contains('cancel')) return (const Color(0xFFFFE6E6), const Color(0xFFB00020));
    return (const Color(0xFFF1F3F4), const Color(0xFF5F6368));
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
