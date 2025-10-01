import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:vertecx/data/repositories/appointmentRepositories/appointment_repository.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_bloc.dart';

import 'package:vertecx/presentation/routes/app_routes.dart';
import 'package:vertecx/presentation/pages/appointementPage/appointment_page.dart';
import 'package:vertecx/presentation/pages/user_list_page.dart';
import 'package:vertecx/presentation/pages/categoryProducts_list_page.dart';
import 'package:vertecx/presentation/pages/dashboard_page.dart';
import 'package:vertecx/presentation/pages/profile_page.dart';
import 'package:vertecx/presentation/pages/login_page.dart';
import 'package:vertecx/presentation/pages/home/homePage.dart';

import 'package:vertecx/presentation/pages/hubs/section_hub_page.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalendarBloc(AppointmentRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.home: (_) => const Home(),

          AppRoutes.userList: (_) => const UserListPage(),
          AppRoutes.categoryProduct: (_) => const CategoryProductListPage(),
          AppRoutes.appointment: (_) => const CalendarPage(),
          AppRoutes.dashboard: (_) => const DashboardPage(),
          AppRoutes.profile: (_) => const ProfilePage(),

          // Hubs
          AppRoutes.purchasesHub: (_) => const PurchasesHubPage(),
          AppRoutes.productsHub:  (_) => const ProductsHubPage(),
          AppRoutes.servicesHub:  (_) => const ServicesHubPage(),
          AppRoutes.salesHub:     (_) => const SalesHubPage(),

          // Placeholders rápidos: sustitúyelos por tus pantallas reales
          AppRoutes.providers:        (_) => const _Placeholder('Proveedores'),
          AppRoutes.purchaseOrders:   (_) => const _Placeholder('Órdenes de compra'),
          AppRoutes.purchases:        (_) => const _Placeholder('Compras'),
          AppRoutes.purchasesCharts:  (_) => const _Placeholder('Gráficas de compras'),
          AppRoutes.productCategories:(_) => const _Placeholder('Categorías de productos'),
          AppRoutes.products:         (_) => const _Placeholder('Productos'),
          AppRoutes.services:         (_) => const _Placeholder('Servicios'),
          AppRoutes.technicians:      (_) => const _Placeholder('Técnicos'),
          AppRoutes.sales:            (_) => const _Placeholder('Ventas'),
          AppRoutes.clients:          (_) => const _Placeholder('Clientes'),
          AppRoutes.requests:         (_) => const _Placeholder('Solicitudes'),
          AppRoutes.salesOrders:      (_) => const _Placeholder('Órdenes'),
          AppRoutes.salesAppointments:(_) => const _Placeholder('Citas'),
        },
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: Center(
        child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
