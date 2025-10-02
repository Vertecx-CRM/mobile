import 'package:flutter/material.dart';
import 'package:vertecx/data/models/products/product_model.dart';

class ProductDetailWidget extends StatelessWidget {
  final ProductModel product;

  const ProductDetailWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              // Contenido principal
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Barra para arrastrar
                    Center(
                      child: Container(
                        height: 5,
                        width: 50,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Nombre
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Imagen
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product.imagePath,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Descripción
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(thickness: 1),

                    // Estado
                    Row(
                      children: [
                        const Text(
                          "Estado: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff525252),
                          ),
                        ),
                        Text(
                          product.statusString,
                          style: TextStyle(
                            color: product.status == ProductStatus.activo
                                ? Colors.green
                                : const Color(0xFFB20000),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Divider(thickness: 1),

                    // Precio
                    Row(
                      children: [
                        const Text(
                          "Precio: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff525252),
                          ),
                        ),
                        Text(
                          product.formattedPrice,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Divider(thickness: 1),

                    // Stock
                    Row(
                      children: [
                        const Text(
                          "Stock: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff525252),
                          ),
                        ),
                        Text(
                          product.stockString,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Divider(thickness: 1),

                    // Categoría
                    Row(
                      children: [
                        const Text(
                          "Categoría: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff525252),
                          ),
                        ),
                        Text(
                          product.category ?? "N/A",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Divider(thickness: 1),

                    // ID
                    Row(
                      children: [
                        const Text(
                          "ID: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff525252),
                          ),
                        ),
                        Text(
                          product.id,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // ❌ Botón de cerrar arriba a la derecha
              Positioned(
                right: 0,
                child: IconButton(
                  icon: ImageIcon(AssetImage("assets/icons/Close.png")),
                  iconSize: 44,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
