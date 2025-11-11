import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/data/models/dashboard/dashboard_models.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/appointment_repository.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_bloc.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_event.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_state.dart';
import 'package:vertecx/data/repositories/dashboard/bloc/dashboard_bloc.dart';
import 'package:vertecx/data/repositories/dashboard/bloc/dashboard_event.dart';
import 'package:vertecx/data/repositories/dashboard/bloc/dashboard_states.dart';
import 'package:vertecx/data/repositories/dashboard/dashboard_repository.dart';
import 'package:vertecx/presentation/widgets/appointmentsWidgets/appointment_card.dart';
import 'package:vertecx/presentation/widgets/dashboardWidgets/dashboardCards_widget.dart';
import 'package:vertecx/presentation/widgets/dashboardWidgets/graphhStates_widget.dart';
import 'package:vertecx/presentation/widgets/dashboardWidgets/pieChart_widget.dart';
import '../widgets/dashboardWidgets/barChart_widget.dart';
import '../widgets/dashboardWidgets/graphLines_widget.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/app_top_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SalesBloc(SalesRepository())..add(LoadSalesEvent())),
        BlocProvider(create: (_) => ClientsBloc(ClientsRepository())..add(LoadClientsEvent())),
        BlocProvider(create: (_) => PurchasesBloc(PurchasesRepository())..add(LoadPurchasesEvent())),
        BlocProvider(create: (_) => AppointmentsBloc(AppointmentsRepository())..add(LoadAppointmentsEvent())),
        BlocProvider(create: (_) => OrdersBloc(OrdersRepository())..add(LoadOrdersEvent())),
        BlocProvider(create: (_) => ProductsBloc(ProductsRepository())..add(LoadProductsEvent())),
        BlocProvider(create: (_) => CalendarBloc(AppointmentRepository())..add(LoadAllAppointments())),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFE8E8E8),
        appBar: const AppTopBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.2,
                  children: [
                    BlocBuilder<SalesBloc, SalesState>(
                      builder: (context, state) {
                        if (state is SalesLoaded) {
                          final total = state.sales.fold<double>(0.0, (sum, s) => sum + s.amount);
                          return SummaryCard(
                            icon: Icons.attach_money,
                            iconColor: Colors.green,
                            title: "Ventas:",
                            value: "\$${total.toStringAsFixed(0)}",
                          );
                        }
                        return const SummaryCard(
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                          title: "Ventas:",
                          value: "...",
                        );
                      },
                    ),
                    BlocBuilder<PurchasesBloc, PurchasesState>(
                      builder: (context, state) {
                        if (state is PurchasesLoaded) {
                          final total = state.purchases.fold<double>(0.0, (sum, s) => sum + s.amount);
                          return SummaryCard(
                            icon: Icons.shopping_cart,
                            iconColor: Colors.red,
                            title: "Compras:",
                            value: "\$${total.toStringAsFixed(0)}",
                          );
                        }
                        return const SummaryCard(
                          icon: Icons.shopping_cart,
                          iconColor: Colors.red,
                          title: "Compras:",
                          value: "...",
                        );
                      },
                    ),
                    BlocBuilder<AppointmentsBloc, AppointmentsState>(
                      builder: (context, state) {
                        if (state is AppointmentsLoaded) {
                          final total = state.completadas + state.pendientes + state.enProgreso + state.anuladas;
                          return SummaryCard(
                            icon: Icons.event_note,
                            iconColor: Colors.black87,
                            title: "Citas:",
                            value: total.toString(),
                          );
                        }
                        return const SummaryCard(
                          icon: Icons.event_note,
                          iconColor: Colors.black87,
                          title: "Citas:",
                          value: "...",
                        );
                      },
                    ),
                    BlocBuilder<OrdersBloc, OrdersState>(
                      builder: (context, state) {
                        if (state is OrdersLoaded) {
                          final total = state.completadas + state.pendientes + state.enProceso + state.canceladas;
                          return SummaryCard(
                            icon: Icons.inventory,
                            iconColor: Colors.black87,
                            title: "Órdenes:",
                            value: total.toString(),
                          );
                        }
                        return const SummaryCard(
                          icon: Icons.inventory,
                          iconColor: Colors.black87,
                          title: "Órdenes:",
                          value: "...",
                        );
                      },
                    ),
                  ],
                ),
                BlocBuilder<SalesBloc, SalesState>(
                  builder: (context, state) {
                    if (state is SalesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SalesLoaded) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: YearSalesChartWidget(title: "Ventas", sales: state.sales),
                      );
                    } else if (state is MonthlySalesLoaded) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: MonthSalesChartWidget(month: state.month, dailySales: state.dailySales),
                      );
                    } else if (state is SalesError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox(height: 20);
                  },
                ),
                BlocBuilder<ClientsBloc, ClientsState>(
                  builder: (context, state) {
                    if (state is ClientsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ClientsLoaded) {
                      return YearSalesChartWidget(
                        title: "Clientes",
                        sales: state.clients.map((c) => Sales(month: c.month, amount: c.amount)).toList(),
                        isClientChart: true,
                      );
                    } else if (state is MonthlyClientsLoaded) {
                      return MonthSalesChartWidget(
                        month: state.month,
                        dailySales: state.dailyClients,
                        isClientChart: true,
                      );
                    } else if (state is ClientsError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox(height: 20);
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<PurchasesBloc, PurchasesState>(
                  builder: (context, state) {
                    if (state is PurchasesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PurchasesLoaded) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: YearSalesChartWidget(
                          title: "Compras",
                          sales: state.purchases,
                          isPurchasesChart: true,
                        ),
                      );
                    } else if (state is MonthlyPurchasesLoaded) {
                      return MonthSalesChartWidget(
                        month: state.month,
                        dailySales: state.dailyPurchases,
                        isPurchasesChart: true,
                      );
                    } else if (state is PurchasesError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox(height: 20);
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<AppointmentsBloc, AppointmentsState>(
                  builder: (context, state) {
                    if (state is AppointmentsLoaded) {
                      return StateChartWidget(
                        title: "Citas",
                        description: "Comparación de citas en pendientes, en proceso y completadas",
                        labels: ["Completados", "Pendientes", "En progreso", "Anulada"],
                        values: [state.completadas, state.pendientes, state.enProgreso, state.anuladas],
                      );
                    }
                    return const SizedBox(height: 20);
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<OrdersBloc, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoaded) {
                      return StateChartWidget(
                        title: "Órdenes",
                        description: "Comparación de órdenes en pendientes, en proceso y completadas",
                        labels: ["Completados", "Pendientes", "En progreso", "Anulada"],
                        values: [state.completadas, state.pendientes, state.enProceso, state.canceladas],
                      );
                    }
                    return const SizedBox(height: 20);
                  },
                ),
                const SizedBox(height: 20),
                const ProductsPieChartWidget(),
                const SizedBox(height: 20),
                BlocBuilder<CalendarBloc, CalendarState>(
                  builder: (context, state) {
                    if (state is CalendarLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AllAppointmentsLoaded) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.event_note, color: Colors.black, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  "Todas las citas",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...state.appointments.map((cita) => AppointmentCard(cita: cita)).toList(),
                          ],
                        ),
                      );
                    } else if (state is CalendarError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
