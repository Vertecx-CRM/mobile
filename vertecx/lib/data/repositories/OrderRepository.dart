import 'package:vertecx/data/models/OrderService.dart';

class OrderRepository {
  Future<List<OrderService>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      OrderService(
        id: 1,
        titulo: 'Mantenimiento a una cámara',
        tecnico: 'Mantenimiento',
        fechaCreacion: DateTime(2025, 9, 18),
        estado: OrderServiceStatus.completada,
      ),
      OrderService(
        id: 2,
        titulo: 'Mantenimiento a una cámara',
        tecnico: 'Mantenimiento',
        fechaCreacion: DateTime(2025, 9, 18),
        estado: OrderServiceStatus.pendiente,
      ),
      OrderService(
        id: 3,
        titulo: 'Mantenimiento a una cámara',
        tecnico: 'Instalación',
        fechaCreacion: DateTime(2025, 9, 18),
        estado: OrderServiceStatus.anulada,
      ),
      OrderService(
        id: 4,
        titulo: 'Mantenimiento a una cámara',
        tecnico: 'Sustituciones',
        fechaCreacion: DateTime(2025, 9, 18),
        estado: OrderServiceStatus.enProgreso,
      ),
      OrderService(
        id: 5,
        titulo: 'Mantenimiento a una cámara',
        tecnico: 'Mantenimiento',
        fechaCreacion: DateTime(2025, 9, 18),
        estado: OrderServiceStatus.pendiente,
      ),
    ];
  }
}
