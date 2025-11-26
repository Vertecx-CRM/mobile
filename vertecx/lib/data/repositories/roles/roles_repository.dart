import 'package:vertecx/data/models/roles/role_model.dart';
import 'package:vertecx/data/services/roles_service.dart';

class RolesRepository {
  final RolesService _service = RolesService();

  Future<List<RoleModel>> fetchRoles() {
    return _service.getRoles();
  }
}
