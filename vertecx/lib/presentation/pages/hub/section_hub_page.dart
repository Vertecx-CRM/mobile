import 'package:flutter/material.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart';

class SectionHubItem {
  final IconData icon;
  final String label;
  final String routeName;
  const SectionHubItem({required this.icon, required this.label, required this.routeName});
}

class SectionHubPage extends StatelessWidget {
  final String title;
  final List<SectionHubItem> items;
  const SectionHubPage({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB20000),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 1.15,
                ),
                itemBuilder: (_, i) {
                  final it = items[i];
                  return _HubCard(
                    icon: it.icon,
                    label: it.label,
                    onTap: () => Navigator.of(context).pushNamed(it.routeName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HubCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: const Color(0xFFB20000)),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Hubs concretos

class PurchasesHubPage extends StatelessWidget {
  const PurchasesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionHubPage(
      title: 'Compras',
      items: const [
        SectionHubItem(icon: Icons.group,           label: 'Proveedores',         routeName: AppRoutes.providers),
        SectionHubItem(icon: Icons.list_alt,        label: 'Órdenes de compra',   routeName: AppRoutes.purchaseOrders),
        SectionHubItem(icon: Icons.shopping_cart,   label: 'Compras',             routeName: AppRoutes.purchases),
        SectionHubItem(icon: Icons.insert_chart,    label: 'Gráficas',            routeName: AppRoutes.purchasesCharts),
      ],
    );
  }
}

class ProductsHubPage extends StatelessWidget {
  const ProductsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionHubPage(
      title: 'Productos',
      items: const [
        SectionHubItem(icon: Icons.category,        label: 'Categorías',          routeName: AppRoutes.productCategories),
        SectionHubItem(icon: Icons.inventory_2,     label: 'Productos',          routeName: AppRoutes.productsList),
      ],
    );
  }
}

class ServicesHubPage extends StatelessWidget {
  const ServicesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionHubPage(
      title: 'Servicios',
      items: const [
        SectionHubItem(icon: Icons.design_services, label: 'Servicios',           routeName: AppRoutes.servicesList),
        SectionHubItem(icon: Icons.handyman,        label: 'Técnicos',            routeName: AppRoutes.techniciansList),
      ],
    );
  }
}

class SalesHubPage extends StatelessWidget {
  const SalesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionHubPage(
      title: 'Ventas',
      items: const [
        SectionHubItem(icon: Icons.point_of_sale,   label: 'Ventas',              routeName: AppRoutes.sales),
        SectionHubItem(icon: Icons.people,          label: 'Clientes',            routeName: AppRoutes.clients),
        SectionHubItem(icon: Icons.assignment,      label: 'Solicitudes',         routeName: AppRoutes.requests),
        SectionHubItem(icon: Icons.inventory,       label: 'Órdenes de Servicio', routeName: AppRoutes.salesOrders),
        SectionHubItem(icon: Icons.event,           label: 'Citas',               routeName: AppRoutes.salesAppointments),
      ],
    );
  }
}
