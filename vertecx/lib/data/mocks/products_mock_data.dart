import 'package:vertecx/data/models/products/product_model.dart';

final List<ProductModel> mockProducts = [
  ProductModel(
    id: "1",
    name: "Unidad de disco duro HP",
    status: ProductStatus.inactivo,
    price: 2000.00,
    description: "Disco duro externo de 1TB, USB 3.0.",
    imagePath: "assets/imgs/disk.png",
    stock: 15,
  ),
  ProductModel(
    id: "2",
    name: "Computador Gamer JANUS",
    status: ProductStatus.activo,
    price: 20000.00,
    description: "Computador con iPhone 15 Pro, 256GB.",
    imagePath: "assets/imgs/pcGamer.png",
    stock: 10,
    category: "Computadores y laptops",
  ),
  ProductModel(
    id: "3",
    name: "Tp-link, Cámara Ip",
    status: ProductStatus.activo,
    price: 3000.00,
    description: "Cámara de seguridad con visión nocturna y audio bidireccional.",
    imagePath: "assets/imgs/camera.png",
    stock: 15,
  ),
];
