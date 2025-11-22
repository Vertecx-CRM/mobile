import 'package:flutter/material.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/app_top_bar.dart';
import '../widgets/components/search/search.dart';
import '../widgets/productsWidgets/product_card_widget.dart';

import 'package:vertecx/data/mocks/products_mock_data.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();
  int _productsToShow = 4; // cantidad inicial de productos
  String _searchQuery = "";

  void _loadMoreProducts() {
    setState(() {
      _productsToShow = (_productsToShow + 2).clamp(0, mockProducts.length);
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // filtrar productos por búsqueda
    final filteredProducts = mockProducts
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final products = filteredProducts.take(_productsToShow).toList();
    final allProductsLoaded = _productsToShow >= filteredProducts.length;

    return Scaffold(
      appBar: const AppTopBar(),
      backgroundColor: const Color(0xFFE8E8E8),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            
            const SizedBox(height: 20),

            // buscador
            Buscar(
              hintText: "Buscar producto...",
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),

            const SizedBox(height: 20),

            // lista de productos filtrados
            if (products.isNotEmpty)
              ...products.map((p) => ProductCardWidget(product: p))
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "No se encontraron productos",
                  style: TextStyle(
                    color: Color(0xFFB20000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // botón o mensaje final
            if (filteredProducts.isNotEmpty)
              if (!allProductsLoaded)
                TextButton(
                  onPressed: _loadMoreProducts,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/Vector.png",
                        width: 20,
                        height: 20,
                      ),
                      const Text(
                        "Cargar más productos",
                        style: TextStyle(color: Color(0xFFB20000)),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Ya están todos los productos",
                    style: TextStyle(
                      color: Color(0xFFB20000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // botón flotante para subir
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFFB20000),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}
