import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vertecx/data/models/appointments/appointment_model.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_bloc.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_event.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_state.dart';
import 'package:vertecx/presentation/helpers/app_dialogs.dart';
import '../../themes/appointment_colors.dart';
import '../../../data/domain/rules/appointment_state_rules.dart';

class AppointmentServiceDetail extends StatelessWidget {
  final AppointmentEvent cita;

  const AppointmentServiceDetail({super.key, required this.cita});

  String formatFecha(DateTime fecha, String inicio, String fin) {
    final formato = DateFormat("dd/MM/yyyy");
    return "${formato.format(fecha)}, $inicio - $fin";
  }

  Widget _buildRow(
    String label,
    String value, {
    Color color = const Color(0xFF666666),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        // Buscar la cita actualizada desde el bloc
        AppointmentEvent currentCita = cita;

        if (state is CalendarLoaded) {
          final updated = state.appointments
              .firstWhere((a) => a.id == cita.id, orElse: () => cita);
          currentCita = updated;
        }

        final fecha = DateTime(currentCita.anio, currentCita.mes, currentCita.dia);
        final estado = AppointmentColors.estadoStyles[currentCita.estado] ??
            AppointmentColors.estadoStyles["Pendiente"]!;

        return Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 Línea vertical a la izquierda
                Container(
                  width: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB20000),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),

                // 🔹 Contenido del card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estado interactivo con PopupMenu
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              AppDialogs.showConfirmChangeStatus(
                                context: context,
                                title: "Cambiar estado",
                                message:
                                    "¿Seguro que deseas cambiar el estado a $value?",
                                onConfirm: () {
                                  context.read<CalendarBloc>().add(
                                        UpdateAppointmentStatus(
                                          appointmentId: currentCita.id,
                                          newStatus: value,
                                        ),
                                      );

                                  AppDialogs.showSuccessMessage(
                                    context,
                                    "Estado cambiado a $value",
                                  );
                                },
                              );
                            },
                            itemBuilder: (context) {
                              final opciones =
                                  getOpcionesEstado(
                                      currentCita.estado);
                              return opciones
                                  .map((e) => PopupMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList();
                            },
                            enabled: getOpcionesEstado(
                                    currentCita.estado)
                                .isNotEmpty,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: estado["bg"],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                currentCita.estado,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: estado["text"],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Fecha y hora
                        Text(
                          formatFecha(
                            fecha,
                            currentCita.horaInicio,
                            currentCita.horaFin,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),

                        const Divider(
                          height: 24,
                          thickness: 1,
                          color: Color(0xFFE8E8E8),
                        ),

                        // Detalle del servicio
                        const Text(
                          "Detalle del servicio",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildRow("ID de orden:", currentCita.orden.id),
                        _buildRow("Cliente:", currentCita.orden.nombreCliente),
                        _buildRow("Dirección:", currentCita.orden.direccion),
                        _buildRow("Servicio:", currentCita.orden.tipoServicio),
                        if (currentCita.orden.tipoMantenimiento != null)
                          _buildRow(
                            "Mantenimiento:",
                            currentCita.orden.tipoMantenimiento!,
                          ),
                        _buildRow("Descripción:", currentCita.orden.descripcion),

                        const SizedBox(height: 10),
                        Text(
                          "Monto: ${currentCita.orden.monto}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC20000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
