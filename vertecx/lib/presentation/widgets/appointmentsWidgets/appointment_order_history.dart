import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vertecx/data/models/appointments/appointment_model.dart';
import 'package:vertecx/presentation/widgets/appointmentsWidgets/appointment_service_detail.dart';

class AppointmentOrderHistory extends StatelessWidget {
  final Future<AppointmentDetailData> detailFuture;

  const AppointmentOrderHistory({super.key, required this.detailFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppointmentDetailData>(
      future: detailFuture,
      builder: (context, snapshot) {
        final history = snapshot.data?.history;
        if (history == null || history.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Historial",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 10),
              ...history.asMap().entries.map((entry) {
                final description = entry.value.description;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.value.actionLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    if (description != null && description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          description,
                          style: const TextStyle(color: Color(0xFF666666)),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(entry.value.createdAt),
                        style: const TextStyle(color: Color(0xFF6E6E6E)),
                      ),
                    ),
                    if (entry.key != history.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: Color(0xFFE0E0E0)),
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
