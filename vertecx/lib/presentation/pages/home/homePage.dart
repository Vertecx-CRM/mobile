import 'package:flutter/material.dart';
import 'package:vertecx/presentation/pages/dashboard_page.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/app_top_bar.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/side_menu_panel.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final List<String> _permissions;
  late final bool _hasDashboard;

  void _logout() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final perms = args is List<String> ? args : const <String>[];
    _permissions = perms;
    final permsLower = perms.map((p) => p.toLowerCase()).toSet();
    _hasDashboard = permsLower.contains('dashboard.read');
  }

  Widget _buildWelcomeContent() {
    final topBar = const AppTopBar(
      title: 'Inicio',
      centerTitle: true,
      showBack: false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: topBar.preferredSize.height,
          child: topBar,
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Bienvenido a Vertecx',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Selecciona un mÃ³dulo desde el menÃº lateral para comenzar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_hasDashboard) {
      return const DashboardPage();
    }
    return _buildWelcomeContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: SideMenuPanel(
          permissions: _permissions,
          onClose: () => Navigator.of(context).maybePop(),
          onLogout: () {
            Navigator.of(context).maybePop();
            _logout();
          },
        ),
      ),
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: 8,
            left: 8,
            child: SafeArea(
              child: const SideMenuButton(),
            ),
          ),
        ],
      ),
    );
  }
}
