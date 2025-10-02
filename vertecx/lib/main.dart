import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/appointment_repository.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_bloc.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';
import 'package:vertecx/presentation/pages/appointementPage/appointment_page.dart';
import 'package:vertecx/presentation/pages/appointementPage/appointment_page_tecnico.dart';
import 'package:vertecx/presentation/pages/purchase_orders_page.dart';
import 'package:vertecx/presentation/pages/user_list_page.dart';
import 'package:vertecx/presentation/pages/categoryProducts_list_page.dart';
import 'package:vertecx/presentation/pages/dashboard_page.dart';
import 'package:vertecx/presentation/pages/profile_page.dart';
import 'package:vertecx/presentation/pages/login_page.dart';
import 'package:vertecx/presentation/pages/home/homePage.dart';
import 'package:vertecx/presentation/pages/hub/section_hub_page.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart';
import 'package:vertecx/presentation/pages/technicians_page.dart';
import 'package:vertecx/presentation/pages/services_page.dart';
import 'package:vertecx/presentation/pages/roles_page.dart';
import 'package:vertecx/presentation/pages/OrderServicePage.dart';
import 'package:vertecx/presentation/pages/requests_page.dart';


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
          AppRoutes.purchasesHub: (_) => const PurchasesHubPage(),
          AppRoutes.productsHub: (_) => const ProductsHubPage(),
          AppRoutes.servicesHub: (_) => const ServicesHubPage(),
          AppRoutes.salesHub: (_) => const SalesHubPage(),
          AppRoutes.providers: (_) => const _Placeholder('Proveedores'),
          AppRoutes.purchaseOrders: (_) => const PurchaseOrdersPage(),
          AppRoutes.purchases: (_) => const _Placeholder('Compras'),
          AppRoutes.purchasesCharts: (_) => const _Placeholder('Gráficas de compras'),
          AppRoutes.productCategories: (_) => const _Placeholder('Categorías de productos'),
          AppRoutes.productsList: (_) => const _Placeholder('Productos'),
          AppRoutes.servicesList: (_) => const ServicesPage(),
          AppRoutes.techniciansList: (_) => const TechniciansPage(),
          AppRoutes.sales: (_) => const _Placeholder('Ventas'),
          AppRoutes.clients: (_) => const _Placeholder('Clientes'),
          AppRoutes.requests: (_) => const RequestsPage(),
          AppRoutes.salesOrders: (_) => const OrderServicePage(),
          AppRoutes.salesAppointments: (_) => const _Placeholder('Citas'),
          AppRoutes.rolesList: (_) => const RolesPage(),
          AppRoutes.techHome: (_) => const AppointmentPageTecnico(),
          AppRoutes.techHub: (_) => const TechnicianHubPage(),
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
        child: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
    );
    }
}
