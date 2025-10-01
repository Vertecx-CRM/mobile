import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

// BLoC / repos
import 'package:vertecx/data/repositories/appointmentRepositories/appointment_repository.dart';
import 'package:vertecx/data/repositories/appointmentRepositories/bloc/calendar_bloc.dart';

// Rutas y páginas
import 'package:vertecx/presentation/routes/app_routes.dart';
import 'package:vertecx/presentation/pages/appointementPage/appointment_page.dart';
import 'package:vertecx/presentation/pages/user_list_page.dart';
import 'package:vertecx/presentation/pages/categoryProducts_list_page.dart';
import './presentation/pages/dashboard_page.dart';

// Widgets
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vertecx/presentation/widgets/AppBottomNav.dart';

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
        initialRoute: AppRoutes.home,
        routes: {
          // Home usa el BottomNav nuevo
          AppRoutes.home: (_) => const Home(),

          // Rutas existentes
          AppRoutes.userList: (_) => const UserListPage(),
          AppRoutes.categoryProduct: (_) => const CategoryProductListPage(),
          AppRoutes.appointment: (_) => const CalendarPage(),
          AppRoutes.dashboard: (_) => const DashboardPage(),
        },
      ),
    );
  }
}

/// ---------- HOME con Bottom Nav + Quick Actions ----------

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tab = 2;
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final navHeight = kBottomNavigationBarHeight + bottomSafe;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const SizedBox.expand(),
          if (_menuOpen) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _menuOpen = false),
                child: const ColoredBox(color: Colors.black45),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _QuickActionsPanel(
                bottomPadding: navHeight,
                onClose: () => setState(() => _menuOpen = false),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tab,
        menuOpen: _menuOpen,
        onItemTap: (i) => setState(() => _tab = i),
        onMenuToggle: () => setState(() => _menuOpen = !_menuOpen),
      ),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel({required this.bottomPadding, required this.onClose});
  final double bottomPadding;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    const wine = Color(0xFF5C0F0F);
    const red = Color(0xFFB20000);

    final actions = const [
      ('Compras',   'assets/image/truck.svg'),
      ('Usuarios',  'assets/image/user.svg'),
      ('Roles',     'assets/image/icon.svg'),
      ('Ventas',    'assets/image/fi-rs-shopping-cart-add.svg'),
      ('Productos', 'assets/image/box.svg'),
      ('Servicios', 'assets/image/tool.svg'),
    ];

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: wine,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: actions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, i) {
                    final a = actions[i];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: onClose,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  a.$2,
                                  width: 34,
                                  height: 34,
                                  colorFilter: const ColorFilter.mode(red, BlendMode.srcIn),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  a.$1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
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
