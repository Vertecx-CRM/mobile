enum SaleItemType { product, service }

class SaleItemModel {
  final String name;
  final double price;
  final int quantity;
  final SaleItemType type;

  SaleItemModel({
    required this.name,
    required this.price,
    required this.quantity,
    required this.type,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    final itemTypeStr = json['itemtype'] as String;
    final itemType = itemTypeStr.toLowerCase() == 'product'
        ? SaleItemType.product
        : SaleItemType.service;

    return SaleItemModel(
      name: json['name'] ?? 'Nombre no disponible',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      type: itemType,
    );
  }

  double get total => price * quantity;

  String get formattedPrice {
    return "\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}";
  }
}
