import 'package:vertecx/data/models/request_model.dart';

abstract class IRequestRepository {
  Future<List<RequestModel>> getAll();
}

class RequestRepositoryMock implements IRequestRepository {
  @override
  Future<List<RequestModel>> getAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final fecha = DateTime(2025, 11, 9);

    // OJO: lista SIN 'const' y elementos SIN 'const'
    return <RequestModel>[
      RequestModel(id: 1, titulo: 'Mantenimiento a una camara', tipo: 'Mantenimientos', fecha: fecha, estado: Estado.aprobada),
      RequestModel(id: 2, titulo: 'Mantenimiento a una camara', tipo: 'Mantenimientos', fecha: fecha, estado: Estado.pendiente),
      RequestModel(id: 3, titulo: 'Mantenimiento a una camara', tipo: 'Mantenimientos', fecha: fecha, estado: Estado.anulada),
      RequestModel(id: 4, titulo: 'Mantenimiento a una camara', tipo: 'Mantenimientos', fecha: fecha, estado: Estado.aprobada),
      RequestModel(id: 5, titulo: 'Mantenimiento a una camara', tipo: 'Mantenimientos', fecha: fecha, estado: Estado.pendiente),
      RequestModel(id: 6, titulo: 'Mantenimiento a una camara', tipo: 'Mantenimientos', fecha: fecha, estado: Estado.anulada),
    ];
  }
}
