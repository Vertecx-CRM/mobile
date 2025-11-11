import 'package:vertecx/data/models/request/request_model.dart';
import 'package:vertecx/data/services/service_requests_service.dart';

abstract class IRequestRepository {
  Future<List<ServiceRequestModel>> getAll();
}

class RequestsRepository implements IRequestRepository {
  final ServiceRequestsService api;
  const RequestsRepository(this.api);

  @override
  Future<List<ServiceRequestModel>> getAll() {
    return api.getRequests(page: 1, limit: 50);
  }
}
