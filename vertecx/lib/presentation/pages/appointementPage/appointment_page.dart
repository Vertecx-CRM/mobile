import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vertecx/data/mocks/appointments_mock_data.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_bloc.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_event.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_state.dart';
import 'package:vertecx/presentation/widgets/appointmentsWidgets/appointment_card.dart';
import 'package:vertecx/presentation/widgets/appointmentsWidgets/calendar_header.dart';
import 'package:vertecx/presentation/widgets/components/search/search.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Citas'),
      backgroundColor: const Color(0xFFE8E8E8),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Buscar(
              hintText: "Buscar cita...",
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CalendarHeader(
                      focusedDay: _focusedDay,
                      months: months,
                      onPrevious: () {
                        setState(() {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month - 1,
                            _focusedDay.day,
                          );
                        });
                      },
                      onNext: () {
                        setState(() {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month + 1,
                            _focusedDay.day,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      calendarFormat: CalendarFormat.month,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      locale: "es_ES",
                      headerVisible: false,
                      daysOfWeekHeight: 45,
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Color(0xFFFFD6D6),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Color(0xFFB20000),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        weekendStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final hasAppointment = mockAppointments.any(
                            (cita) =>
                                cita.fecha.year == day.year &&
                                cita.fecha.month == day.month &&
                                cita.fecha.day == day.day,
                          );
                          return Container(
                            width: 56,
                            height: 40,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: hasAppointment
                                  ? Border.all(
                                      color: const Color(0xFFCC0000),
                                      width: 3,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 3,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        context
                            .read<CalendarBloc>()
                            .add(LoadAppointmentsForDay(selectedDay));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CalendarLoaded) {
                  final citas = state.appointments.where((cita) {
                    return cita.orden.tipoServicio
                            .toLowerCase()
                            .contains(_searchQuery) ||
                        cita.orden.descripcion
                            .toLowerCase()
                            .contains(_searchQuery) ||
                        cita.orden.tecnicos
                            .map((t) => t.nombre.toLowerCase())
                            .join(" ")
                            .contains(_searchQuery);
                  }).toList();
                  if (citas.isEmpty) {
                    return const Center(child: Text("No hay citas para este día"));
                  }
                  return ListView.builder(
                    itemCount: citas.length,
                    itemBuilder: (context, index) {
                      return AppointmentCard(cita: citas[index]);
                    },
                  );
                } else {
                  return const Center(child: Text("Selecciona un día para ver citas"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
