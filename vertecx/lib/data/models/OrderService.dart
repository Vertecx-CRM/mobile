class OrderService {
  final int id;
  final String titulo;
  final String tecnico;
  final DateTime fechaCreacion;
  final OrderServiceStatus estado;

  OrderService({
    required this.id,
    required this.titulo,
    required this.tecnico,
    required this.fechaCreacion,
    required this.estado,
  });
}

enum OrderServiceStatus { completada, pendiente, anulada, enProgreso }
