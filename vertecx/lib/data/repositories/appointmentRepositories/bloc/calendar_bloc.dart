import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/data/mocks/appointments_mock_data.dart';
import 'package:vertecx/data/models/appointments/appointment_model.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/appointment_repository.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final AppointmentRepository repository;

  CalendarBloc(this.repository) : super(CalendarInitial()) {
    //Cargar citas por día
    on<LoadAppointmentsForDay>((event, emit) async {
      emit(CalendarLoading());
      try {
        final citas = repository.getAppointmentsForDay(event.date);
        emit(CalendarLoaded(selectedDate: event.date, appointments: citas));
      } catch (e) {
        emit(CalendarError("Error al cargar las citas: $e"));
      }
    });

    //Cargar citas por mes
    on<LoadAppointmentsForMonth>((event, emit) async {
      emit(CalendarLoading());
      try {
        final citasPorDia = repository.getAppointmentsForMonth(event.month);
        emit(
          CalendarMonthLoaded(
            month: event.month,
            appointmentsByDay: citasPorDia,
          ),
        );
      } catch (e) {
        emit(CalendarError("Error al cargar las citas del mes: $e"));
      }
    });

    on<LoadAllAppointments>((event, emit) async {
      emit(CalendarLoading());
      try {
        final citas = repository.getAllAppointments();
        emit(AllAppointmentsLoaded(citas));
      } catch (e) {
        emit(CalendarError("Error al cargar todas las citas: $e"));
      }
    });

    on<UpdateAppointmentStatus>((event, emit) async {
      if (state is CalendarLoaded) {
        final currentState = state as CalendarLoaded;

        // 🔹 Actualizamos la lista en memoria
        final updatedAppointments = currentState.appointments.map((a) {
          if (a.id == event.appointmentId) {
            final updated = AppointmentEvent(
              id: a.id,
              horaInicio: a.horaInicio,
              horaFin: a.horaFin,
              dia: a.dia,
              mes: a.mes,
              anio: a.anio,
              orden: a.orden,
              observaciones: a.observaciones,
              estado: event.newStatus,
              subestado: a.subestado,
              motivoCancelacion: a.motivoCancelacion,
              evidencia: a.evidencia,
              comprobantePago: a.comprobantePago,
              tipoCita: a.tipoCita,
              horaCancelacion: a.horaCancelacion,
            );

            // 🔹 También actualizamos el mock global
            final index = mockAppointments.indexWhere((m) => m.id == a.id);
            if (index != -1) {
              mockAppointments[index] = updated;
            }

            return updated;
          }
          return a;
        }).toList();

        emit(
          CalendarLoaded(
            selectedDate: currentState.selectedDate,
            appointments: updatedAppointments,
          ),
        );
      }
    });
  }
}
