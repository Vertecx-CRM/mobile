import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/appointment_repository.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_bloc.dart';
import 'package:vertecx/presentation/pages/appointementPage/appointment_page.dart';
import 'package:vertecx/presentation/pages/appointementPage/appointment_page_tecnico.dart';
import 'package:vertecx/presentation/pages/purchase_orders_page.dart';
import 'package:vertecx/presentation/pages/user_list_page.dart';
import 'package:vertecx/presentation/pages/categoryProducts_list_page.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import './presentation/pages/dashboard_page.dart';
import './presentation/pages/products_page.dart';
import './presentation/pages/roles_page.dart';
import './presentation/pages/technicians_page.dart';
import './presentation/pages/services_page.dart';
import './presentation/pages/clients_page.dart';
import 'package:vertecx/presentation/widgets/general_scaffold.dart';
import 'package:vertecx/presentation/pages/sales_page.dart';

void main() async {
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
        BlocProvider(
          create: (context) => CalendarBloc(AppointmentRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => const HomePage(),

          AppRoutes.userList: (context) =>
              const AppScaffold(title: "Usuarios", body: UserListPage()),

          AppRoutes.categoryProduct: (context) => const AppScaffold(
            title: "Categorías de Productos",
            body: CategoryProductListPage(),
          ),

          AppRoutes.appointment: (context) =>
              const AppScaffold(title: "Citas", body: CalendarPage()),

          AppRoutes.dashboard: (context) =>
              const AppScaffold(title: "Dashboard", body: DashboardPage()),
          
          AppRoutes.dashboard: (context) =>
              const AppScaffold(title: "Cita de técnico", body: AppointmentPageTecnico()),

          AppRoutes.products: (context) =>
              const AppScaffold(title: "Productos", body: ProductsPage()),

          AppRoutes.roles: (context) =>
              const AppScaffold(title: "Roles", body: RolesPage()),

          AppRoutes.technicians: (context) =>
              const AppScaffold(title: "Técnicos", body: TechniciansPage()),

          AppRoutes.services: (context) =>
              const AppScaffold(title: "Servicios", body: ServicesPage()),

          AppRoutes.clients: (context) =>
              const AppScaffold(title: "Clientes", body: ClientsPage()),
          AppRoutes.sales: (context) =>
              const AppScaffold(title: "Ventas", body: SalesPage()),
          AppRoutes.purchaseOrders: (context) => const AppScaffold(
            title: "Órdenes de Compra",
            body: PurchaseOrdersPage(),
          ),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Frontend')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Ir a Lista de Usuarios'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.userList),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.category),
              label: const Text('Ir a Categorías de Productos'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.categoryProduct),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Ir a Citas'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.appointment),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.dashboard),
              label: const Text('Ir a dashboard'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.dashboard),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Ir a Productos'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.products),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Ir a Roles'),
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.roles),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.build),
              label: const Text('Ir a Técnicos'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.technicians),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.miscellaneous_services),
              label: const Text('Ir a Servicios'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.services),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.build), 
              label: const Text('Ir a Citas Técnico'),
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.appointmentTechnician),
              icon: const Icon(Icons.person),
              label: const Text('Ir a Clientes'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.clients),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.point_of_sale),
              label: const Text('Ir a Ventas'),
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.sales),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: const Text('Ir a Órdenes de Compra'),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.purchaseOrders),
            ),
          ],
        ),
      ),
    );
  }
}
