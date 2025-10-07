import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vertecx/blocs/requests_bloc.dart';
import 'package:vertecx/blocs/requests_event.dart';
import 'package:vertecx/blocs/requests_state.dart';
import 'package:vertecx/data/repositories/request_repository.dart';
import 'package:vertecx/presentation/widgets/request_card.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestsBloc>(
      create: (_) => RequestsBloc(RequestRepositoryMock())
        ..add(const RequestsLoadRequested()),
      child: const _RequestsScaffold(),
    );
  }
}

class _RequestsScaffold extends StatefulWidget {
  const _RequestsScaffold();

  @override
  State<_RequestsScaffold> createState() => _RequestsScaffoldState();
}

class _RequestsScaffoldState extends State<_RequestsScaffold> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: const AppTopBar(
        title: 'Solicitudes',
        centerTitle: true,
        showBack: false,
      ),
      // 👇 Menú lateral como en Dashboard
      drawer: const AppSideMenu(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: _SearchBox(),
          ),
          Expanded(child: _RequestsList(controller: _scrollController)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'requests_scroll_top_fab',
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFFB20000),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  const _RequestsList({required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(
            child: Text(
              state.error!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // Sin resultados (lista vacía)
        if (state.visible.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No hay solicitudes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB20000),
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          itemCount: state.visible.length + 1, // Uno extra para el footer
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            if (i < state.visible.length) {
              return RequestCard(data: state.visible[i]);
            }

            // FOOTER
            if (state.hasMore) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: state.loadingMore
                        ? null
                        : () => context
                            .read<RequestsBloc>()
                            .add(const RequestsLoadMorePressed()),
                    icon: state.loadingMore
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.expand_more),
                    label: const Text('Cargar más solicitudes'),
                  ),
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'No existen más solicitudes',
                    style: TextStyle(
                      color: Color(0xFFB20000),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _SearchBox extends StatefulWidget {
  const _SearchBox();

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  final c = TextEditingController();

  @override
  void initState() {
    super.initState();
    c.addListener(() {
      context.read<RequestsBloc>().add(RequestsSearchChanged(c.text));
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            color: Color(0x11000000),
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, size: 20, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: c,
              decoration: const InputDecoration(
                hintText: 'Buscar  Solicitudes...',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          BlocBuilder<RequestsBloc, RequestsState>(
            builder: (context, state) {
              if (state.query.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => c.clear(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ====================
/// Menú lateral común
/// ====================
class AppSideMenu extends StatelessWidget {
  const AppSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const wine = Color(0xFF5C0F0F);
    const red  = Color(0xFFB20000);

    Widget item({
      required IconData icon,
      required String label,
      required String route,
      bool selected = false,
    }) {
      return ListTile(
        leading: Icon(icon, color: selected ? red : Colors.black87),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? red : Colors.black87,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // cierra el drawer
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.of(context).pushNamed(route);
          }
        },
      );
    }

    final current = ModalRoute.of(context)?.settings.name ?? '';

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0x11000000))),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFE8E8E8),
                    child: Icon(Icons.engineering, color: wine),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vertecx',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: wine,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  item(icon: Icons.dashboard_outlined, label: 'Dashboard', route: AppRoutes.dashboard, selected: current == AppRoutes.dashboard),
                  item(icon: Icons.list_alt_outlined,    label: 'Solicitudes', route: AppRoutes.requests,   selected: current == AppRoutes.requests),
                  item(icon: Icons.inventory_2_outlined, label: 'Órdenes',    route: AppRoutes.salesOrders,selected: current == AppRoutes.salesOrders),
                  item(icon: Icons.event_note_outlined,  label: 'Citas',       route: AppRoutes.appointment,selected: current == AppRoutes.appointment),
                  item(icon: Icons.store_mall_directory_outlined, label: 'Proveedores', route: AppRoutes.providers, selected: current == AppRoutes.providers),
                  item(icon: Icons.people_alt_outlined,  label: 'Clientes',     route: AppRoutes.clients,    selected: current == AppRoutes.clients),
                  item(icon: Icons.shopping_bag_outlined,label: 'Productos',    route: AppRoutes.productsList,selected: current == AppRoutes.productsList),
                  item(icon: Icons.home_repair_service_outlined,label: 'Servicios', route: AppRoutes.servicesList, selected: current == AppRoutes.servicesList),
                  const Divider(),
                  item(icon: Icons.person_outline,       label: 'Mi Perfil',    route: AppRoutes.profile,    selected: current == AppRoutes.profile),
                ],
              ),
            ),

            // Footer versión / logo
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'v1.0.0',
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
