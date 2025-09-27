class AppRoutes {
  // Ruta inicial o de autenticación (si aún no hay login)
  static const String home = '/'; 
  
  // Ruta de la lista de usuarios (donde usaremos la UserCardWidget)
  static const String userList = '/users';

  // Opcional: Ruta para ver el detalle de un usuario
  static const String userDetail = '/user-detail';
}