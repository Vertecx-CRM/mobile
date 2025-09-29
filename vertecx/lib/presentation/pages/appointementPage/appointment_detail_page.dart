import 'package:flutter/material.dart';
import 'package:vertecx/data/models/appointments/appointment_model.dart';
import 'package:vertecx/presentation/widgets/appointmentsWidgets/appointment_additional_info.dart';
import 'package:vertecx/presentation/widgets/appointmentsWidgets/appointment_service_detail.dart';
import 'package:vertecx/presentation/widgets/appointmentsWidgets/appointment_technicians_card.dart';
import 'package:vertecx/presentation/widgets/components/header/header.dart';

class AppointmentDetailPage extends StatelessWidget {
  final AppointmentEvent cita;

  const AppointmentDetailPage({super.key, required this.cita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Column(
        children: [
          // 🔹 Encabezado con flecha de volver
          HearderUser(
            title: "Detalle de la Cita",
            iconPath: "assets/icons/userP.png",
            titleSize: 28,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFB20000)),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 🔹 Contenido con scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppointmentServiceDetail(cita: cita),
                  AppointmentTechniciansCard(tecnicos: cita.orden.tecnicos),
                  AppointmentAdditionalInfo(cita: cita),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
