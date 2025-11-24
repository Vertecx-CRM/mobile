import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

// Calendar
import 'package:vertecx/data/repositories/appointmentRepositories/appointment_repository.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_bloc.dart';

// Roles
import 'package:vertecx/data/repositories/roles/roles_repository.dart';
import 'package:vertecx/data/repositories/roles/bloc/roles_bloc.dart';
import 'package:vertecx/data/repositories/roles/bloc/roles_event.dart';

// Technicians
import 'package:vertecx/data/repositories/technicians/technicians_repository.dart';
import 'package:vertecx/data/repositories/technicians/bloc/technicians_bloc.dart';
import 'package:vertecx/data/repositories/technicians/bloc/technicians_event.dart';

// Pages
import 'package:vertecx/presentation/pages/clients_page.dart';
import 'package:vertecx/presentation/pages/products_page.dart';
import 'package:vertecx/presentation/pages/purchases_page.dart';
import 'package:vertecx/presentation/pages/sales_page.dart';
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
import 'package:vertecx/presentation/widgets/navigationWidgets/app_top_bar.dart';
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
        /// CALENDAR
        BlocProvider(
          create: (_) => CalendarBloc(AppointmentRepository()),
        ),

        /// ROLES
        BlocProvider(
          create: (_) => RolesBloc(RolesRepository())..add(LoadRolesEvent()),
        ),

        /// 🔥 TÉCNICOS (nuevo, solo lectura)
        BlocProvider(
          create: (_) => TechniciansBloc(TechniciansRepository())
            ..add(LoadTechniciansEvent()),
        ),
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
          AppRoutes.purchaseOrders: (_) => const PurchaseOrdersPage(),
          AppRoutes.purchases: (_) => const PurchasesPage(),
          AppRoutes.productCategories: (_) => CategoryProductListPage(),
          AppRoutes.productsList: (_) => const ProductsPage(),
          AppRoutes.servicesList: (_) => const ServicesPage(),
          AppRoutes.techniciansList: (_) => const TechniciansPage(),
          AppRoutes.sales: (_) => const SalesPage(),
          AppRoutes.clients: (_) => const ClientsPage(),
          AppRoutes.requests: (_) => const RequestsPage(),
          AppRoutes.salesOrders: (_) => const OrderServicePage(),
          AppRoutes.salesAppointments: (_) => const AppointmentPageTecnico(),
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
