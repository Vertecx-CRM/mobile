import 'package:flutter/material.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.showBack = false,
    this.extraActions,
  });

  final String? title;
  final bool centerTitle;
  final bool showBack;
  final List<Widget>? extraActions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  String _titleFromRoute(BuildContext context) {
    final name = ModalRoute.of(context)?.settings.name ?? '';
    switch (name) {
      case AppRoutes.home:
        return 'Dashboard';
      case AppRoutes.userList:
        return 'Usuarios';
      case AppRoutes.categoryProduct:
        return 'Productos';
      case AppRoutes.appointment:
        return 'Citas';
      case AppRoutes.dashboard:
        return 'Dashboard';
      case AppRoutes.profile:
        return 'Mi Perfil';
      case AppRoutes.rolesList:
        return 'Roles';
      case AppRoutes.salesOrders:
        return 'Ordenes de Servicio';
      case AppRoutes.requests:
        return 'Solicitudes';
      case AppRoutes.techniciansList:
        return 'Técnicos';
      case AppRoutes.servicesList:
        return 'Servicios';
      case AppRoutes.productsList:
        return 'Productos';
      case AppRoutes.sales:
        return 'Ventas';
      case AppRoutes.purchases:
        return 'Compras';
      case AppRoutes.providers:
        return 'Proveedores';
      case AppRoutes.clients:
        return 'Clientes';
      case AppRoutes.appointment:
        return 'Citas';
      default:
        return 'Sistemas PC';
    }
  }

  void _goProfile(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.profile);
  }

  void _logout(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title ?? _titleFromRoute(context);

    return AppBar(
      elevation: 1.5,
      backgroundColor: Colors.white,
      centerTitle: centerTitle,
      // 👇 esquinas redondeadas abajo
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias, // asegura el recorte del fondo
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(
        resolvedTitle,
        style: const TextStyle(
          color: Color(0xFFB20000),
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (extraActions != null) ...extraActions!,
        PopupMenuButton<_ProfileAction>(
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFEAEAEA),
            child: Icon(Icons.person, color: Colors.black87),
          ),
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: _ProfileAction.view,
              child: ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text('Ver perfil'),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            PopupMenuItem(
              value: _ProfileAction.logout,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar sesión'),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case _ProfileAction.view:
                _goProfile(context);
                break;
              case _ProfileAction.logout:
                _logout(context);
                break;
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

enum _ProfileAction { view, logout }
