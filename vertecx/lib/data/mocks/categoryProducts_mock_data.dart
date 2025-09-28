import 'package:vertecx/data/models/categoryProducts/categoryProducts_model.dart';

final List<CategoryProduct> mockCategoryProducts =
    [
          CategoryProduct(
            id: 0,
            imagenPath: "assets/icons/Server.png",
            nombre: "Servidores",
            descripcion:
                "Descripción de la categoría de servidores, hardware potente para alojar aplicaciones y sitios web.",
            estado: CategoryStatus.inactivo,
          ),
          CategoryProduct(
            id: 0,
            imagenPath: "assets/icons/laptop.png",
            nombre: "Computadores",
            descripcion:
                "Computadoras de escritorio y portátiles para uso personal y profesional, con diversos ajustes.",
            estado: CategoryStatus.activo,
          ),
          CategoryProduct(
            id: 0,
            imagenPath: "assets/icons/red.png",
            nombre: "Redes",
            descripcion:
                "Equipos de red como routers, switches y access points para crear infraestructuras de conexión robustas.",
            estado: CategoryStatus.activo,
          ),
        ]
        .asMap()
        .entries
        .map(
          (e) => CategoryProduct(
            id: e.key + 1,
            imagenPath: e.value.imagenPath,
            nombre: e.value.nombre,
            descripcion: e.value.descripcion,
            estado: e.value.estado,
          ),
        )
        .toList();

        
