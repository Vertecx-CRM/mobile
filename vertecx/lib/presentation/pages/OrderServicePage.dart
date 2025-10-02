import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertecx/blocs/OrderServiceController.dart';
import 'package:vertecx/data/repositories/order_repository.dart';
import 'package:vertecx/presentation/widgets/OrderServiceCard.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart';

class OrderServicePage extends StatelessWidget {
  const OrderServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderServiceController(OrderRepository())..load(),
      child: const _OrderServiceView(),
    );
  }
}

class _OrderServiceView extends StatefulWidget {
  const _OrderServiceView();

  @override
  State<_OrderServiceView> createState() => _OrderServiceViewState();
}

class _OrderServiceViewState extends State<_OrderServiceView> {
  final ScrollController _scrollController = ScrollController();
  int _ordersToShow = 4;

  void _loadMore() {
    final total = context.read<OrderServiceController>().orders.length;
    setState(() {
      _ordersToShow = (_ordersToShow + 2).clamp(0, total);
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrderServiceController>();
    final all = controller.orders;
    final shown = all.take(_ordersToShow).toList();
    final allLoaded = _ordersToShow >= all.length;

    return Scaffold(
      appBar: const AppTopBar(
        title: 'Órdenes de Servicio',
        centerTitle: true,
        showBack: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                onChanged: controller.search,
                decoration: InputDecoration(
                  hintText: 'Buscar Solicitudes...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (shown.isNotEmpty)
              ...shown.map((o) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: OrderCard(order: o),
                  ))
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No se encontraron órdenes',
                  style: TextStyle(color: Color(0xFFB20000), fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 8),
            if (all.isNotEmpty)
              if (!allLoaded)
                TextButton(
                  onPressed: _loadMore,
                  child: Column(
                    children: const [
                      Text('Cargar más órdenes', style: TextStyle(color: Color(0xFFB20000))),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Ya están todas las órdenes',
                    style: TextStyle(color: Color(0xFFB20000), fontWeight: FontWeight.bold),
                  ),
                ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'orders_scroll_top_fab',
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFFB20000),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}
