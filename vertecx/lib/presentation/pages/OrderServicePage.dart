import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertecx/blocs/OrderServiceController.dart';
import 'package:vertecx/data/repositories/OrderRepository.dart';
import 'package:vertecx/presentation/widgets/OrderServiceCard.dart';

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

class _OrderServiceView extends StatelessWidget {
  const _OrderServiceView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrderServiceController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Ordenes De Servicio', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFB20000))),
        centerTitle: false,
        backgroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFEFEFEF),
              child: Icon(Icons.person_outline, color: Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
      body: Column(
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemBuilder: (_, i) => OrderCard(order: controller.orders[i]),
              separatorBuilder: (_, i) => const SizedBox(height: 10),
              itemCount: controller.orders.length,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70, right: 16),
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: const Color(0xFFB20000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Crear Orden', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
