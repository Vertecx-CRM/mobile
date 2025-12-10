import 'package:flutter/material.dart';
import 'package:vertecx/presentation/pages/purchases_page.dart';
import 'package:vertecx/presentation/pages/sales_page.dart';

// Tabs
import 'package:vertecx/presentation/pages/user_list_page.dart';
import 'package:vertecx/presentation/pages/categoryProducts_list_page.dart';
import 'package:vertecx/presentation/pages/dashboard_page.dart';

// Rutas
import 'package:vertecx/presentation/routes/app_routes.dart';

// BottomNav
import 'package:vertecx/presentation/widgets/navigationWidgets/AppBottomNav.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tab = 2;
  bool _menuOpen = false;
  final GlobalKey<UserListPageState> _usersKey = GlobalKey<UserListPageState>();

  void _openProfile() {
    Navigator.of(context).pushNamed(AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final navHeight = kBottomNavigationBarHeight + bottomSafe;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: navHeight),
            child: IndexedStack(
              index: _tab,
              children: [
                const PurchasesPage(), // 1
                const SalesPage(), // 3
                const DashboardPage(), // 2 (inicio)
                UserListPage(key: _usersKey), // 0
                const SizedBox.shrink(), // 4 (boton menu)
              ],
            ),
          ),
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
          if (_menuOpen) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _menuOpen = false),
                child: const ColoredBox(color: Colors.black45),
              ),
            ),
          ],
          AnimatedPositioned(
            duration: const Duration(milliseconds: 510),
            curve: Curves.easeOut,
            top: 0,
            bottom: 0,
            left: _menuOpen ? 0 : -260,
            child: _SideMenuPanel(
              onClose: () => setState(() => _menuOpen = false),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNav(
          currentIndex: _tab,
          onItemTap: (i) {
            setState(() => _tab = i);
            if (i == 3) {
              _usersKey.currentState?.reloadUsers();
            }
          },
          onProfileTap: _openProfile,
        ),
      ),
    );
  }
}

const _sideMenuWine = Color(0xFFB20000);

class _SideMenuPanel extends StatefulWidget {
  const _SideMenuPanel({
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  State<_SideMenuPanel> createState() => _SideMenuPanelState();
}

class _SideMenuPanelState extends State<_SideMenuPanel> {
  final _expanded = <String>{};

  void _toggle(String label) {
    setState(() {
      if (_expanded.contains(label)) {
        _expanded.remove(label);
      } else {
        _expanded.add(label);
      }
    });
  }

  void _navigate(String route) {
    widget.onClose();
    Navigator.of(context).pushNamed(route);
  }

  Widget _buildItem(_SideMenuItem item) {
    if (!item.hasChildren) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(item.icon, color: Colors.white),
        title: Text(
          item.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () => _navigate(item.route!),
      );
    }

    final isExpanded = _expanded.contains(item.label);
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Icon(item.icon, color: Colors.white),
          title: Text(
            item.label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          trailing: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 380),
            child: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          ),
          onTap: () => _toggle(item.label),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              if (isExpanded)
                ...item.children!.map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      dense: true,
                      leading: const SizedBox.shrink(),
                      title: Text(
                        child.label,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () => _navigate(child.route!),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          width: 250,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: _sideMenuWine,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(4, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: const Text(
                        'v',
                        style: TextStyle(
                          color: _sideMenuWine,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Vertecx',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Panel de gestión',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8),
                  children: _menuItems.map(_buildItem).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideMenuItem {
  const _SideMenuItem({
    required this.label,
    this.icon,
    this.route,
    this.children,
  });

  final String label;
  final IconData? icon;
  final String? route;
  final List<_SideMenuItem>? children;

  bool get hasChildren => children != null && children!.isNotEmpty;
}

const _menuItems = [
  _SideMenuItem(
    label: 'Dashboard',
    icon: Icons.home,
    route: AppRoutes.dashboard,
  ),
  _SideMenuItem(
    label: 'Usuarios',
    icon: Icons.person,
    route: AppRoutes.userList,
  ),
  _SideMenuItem(
    label: 'Roles',
    icon: Icons.group,
    route: AppRoutes.rolesList,
  ),
  _SideMenuItem(
    label: 'Compras',
    icon: Icons.local_shipping,
    children: [
      _SideMenuItem(label: 'Compras', route: AppRoutes.purchases),
      _SideMenuItem(label: 'Orden de compra', route: AppRoutes.purchaseOrders),
    ],
  ),
  _SideMenuItem(
    label: 'Productos',
    icon: Icons.widgets,
    children: [
      _SideMenuItem(label: 'Productos', route: AppRoutes.productsList),
      _SideMenuItem(label: 'Categorías', route: AppRoutes.productCategories),
    ],
  ),
  _SideMenuItem(
    label: 'Servicios',
    icon: Icons.build,
    children: [
      _SideMenuItem(label: 'Servicios', route: AppRoutes.servicesList),
      _SideMenuItem(label: 'Técnicos', route: AppRoutes.techniciansList),
    ],
  ),
  _SideMenuItem(
    label: 'Ventas',
    icon: Icons.shopping_cart,
    children: [
      _SideMenuItem(label: 'Ventas', route: AppRoutes.sales),
      _SideMenuItem(label: 'Clientes', route: AppRoutes.clients),
      _SideMenuItem(label: 'Solicitudes', route: AppRoutes.requests),
      _SideMenuItem(label: 'Ordenes', route: AppRoutes.salesOrders),
      _SideMenuItem(label: 'Citas', route: AppRoutes.salesAppointments),
    ],
  ),
];
