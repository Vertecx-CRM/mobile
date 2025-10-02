class AppRoutes {
  // Core
  static const String login            = '/login';
  static const String home             = '/';
  static const String dashboard        = '/dashboard';
  static const String userList         = '/users';
  static const String categoryProduct  = '/category-products';
  static const String appointment      = '/appointments';
  static const String profile          = '/profile';

  // Hubs
  static const String purchasesHub     = '/hub/purchases';
  static const String productsHub      = '/hub/products';
  static const String servicesHub      = '/hub/services';
  static const String salesHub         = '/hub/sales';
  static const String rolesHub         = '/hub/roles';

  // Compras (subpantallas)
  static const String providers        = '/purchases/providers';
  static const String purchases        = '/purchases/list';
  static const String purchasesCharts  = '/purchases/charts';

  // Productos (subpantallas)
  static const String productCategories = '/products/categories';
  static const String productsList      = '/products/list';

  // Servicios (subpantallas)
  static const String servicesList      = '/services/list';
  static const String techniciansList   = '/services/technicians';
  static const String appointmentTechnician = '/appointment/technician';

  // Ventas (subpantallas)
  static const String clients           = '/sales/clients';
  static const String requests          = '/sales/requests';
  static const String salesOrders       = '/sales/orders';
  static const String salesAppointments = '/sales/appointments';

  // Roles (subpantallas)
  static const String rolesList         = '/roles/list';
  static const String sales = '/sales';
  static const String purchaseOrders = '/purchaseOrders';
}
