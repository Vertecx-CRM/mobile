import 'package:flutter/material.dart';
import 'package:vertecx/core/session_context.dart';
import 'package:vertecx/presentation/pages/dashboard_page.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/app_side_menu.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/app_top_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _menuOpen = false;
  List<String> _permissions = const <String>[];
  bool _hasDashboard = false;

  void _logout() {
    SessionContext.clearAll();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    bool openMenu = false;
    List<String> perms = _permissions.isNotEmpty
        ? _permissions
        : SessionContext.permissions;

    if (args is List<String>) {
      perms = args;
    } else if (args is Map<String, dynamic>) {
      final rawPerms = args['permissions'];
      if (rawPerms is List) {
        perms = rawPerms.map((e) => e.toString()).toList();
      } else if (SessionContext.permissions.isNotEmpty) {
        perms = SessionContext.permissions;
      }
      openMenu = args['openMenu'] == true;
    } else if (SessionContext.permissions.isNotEmpty) {
      perms = SessionContext.permissions;
    }

    _permissions = perms;
    SessionContext.permissions = perms;
    final permsLower = _permissions.map((p) => p.toLowerCase()).toSet();
    _hasDashboard = permsLower.contains('dashboard.read');

    if (openMenu && !_menuOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _menuOpen = true);
      });
    }
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
        SizedBox(height: topBar.preferredSize.height, child: topBar),
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
                    'Selecciona un modulo desde el menu lateral para comenzar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
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
      extendBody: true,
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: 8,
            left: 8,
            child: SafeArea(
              child: Material(
                elevation: 2,
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: IconButton(
                  onPressed: () => setState(() => _menuOpen = !_menuOpen),
                  icon: Icon(
                    _menuOpen ? Icons.close : Icons.menu,
                    color: const Color(0xFFB20000),
                  ),
                ),
              ),
            ),
          ),
          if (_menuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _menuOpen = false),
                child: const ColoredBox(color: Colors.black45),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 510),
            curve: Curves.easeOut,
            top: 0,
            bottom: 0,
            left: _menuOpen ? 0 : -260,
            child: AppSideMenuPanel(
              permissions: _permissions,
              onClose: () => setState(() => _menuOpen = false),
              onLogout: () {
                setState(() => _menuOpen = false);
                _logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
