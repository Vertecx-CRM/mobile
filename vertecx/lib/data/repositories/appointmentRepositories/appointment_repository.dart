import 'package:vertecx/data/models/appointments/appointment_model.dart';
import 'package:vertecx/data/mocks/appointments_mock_data.dart';

class AppointmentRepository {
  /// 🔹 Devuelve las citas de un día específico
  List<AppointmentEvent> getAppointmentsForDay(DateTime date) {
    return mockAppointments
        .where(
          (a) =>
              a.fecha.year == date.year &&
              a.fecha.month == date.month &&
              a.fecha.day == date.day,
        )
        .toList();
  }

  /// 🔹 Devuelve todas las citas agrupadas por día de un mes
  Map<DateTime, List<AppointmentEvent>> getAppointmentsForMonth(
    DateTime month,
  ) {
    final Map<DateTime, List<AppointmentEvent>> citasPorDia = {};

    for (final cita in mockAppointments) {
      final fecha = DateTime(cita.anio, cita.mes, cita.dia);

      if (fecha.year == month.year && fecha.month == month.month) {
        citasPorDia.putIfAbsent(fecha, () => []);
        citasPorDia[fecha]!.add(cita);
      }
    }

    return citasPorDia;
  }

  /// 🔹 Devuelve todas las citas (si se necesita un listado completo)
  List<AppointmentEvent> getAllAppointments() {
    return mockAppointments;
  }
}
