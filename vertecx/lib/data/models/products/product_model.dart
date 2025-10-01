import 'package:intl/intl.dart';

enum ProductStatus { activo, inactivo }

class ProductModel {
  final String id;
  final String name;
  final ProductStatus status;
  final double price;
  final String description;
  final String imagePath;
  final int? stock;
  ProductModel({
    required this.id,
    required this.name,
    required this.status,
    required this.price,
    required this.description,
    required this.imagePath,
    this.stock,
  });

  // Método de utilidad para mostrar el estado como texto
  String get statusString =>
      status == ProductStatus.activo ? "Activo" : "Inactivo";

  // Método para cambiar el estado
  ProductModel toggleStatus() {
    return ProductModel(
      id: id,
      name: name,
      status: status == ProductStatus.activo
          ? ProductStatus.inactivo
          : ProductStatus.activo,
      price: price,
      description: description,
      imagePath: imagePath,
      stock: stock,
    );
  }

  // 🔥 Método para formatear el precio en pesos colombianos
  String get formattedPrice {
    final formatter = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  String get stockString {
    if (stock == null) return "Stock: N/A";
    return stock! > 0 ? "$stock" : "Agotado";
  }
}
