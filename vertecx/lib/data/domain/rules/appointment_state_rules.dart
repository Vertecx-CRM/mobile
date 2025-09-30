  /// Reglas de transición de estado
  List<String> getOpcionesEstado(String estadoActual) {
    switch (estadoActual) {
      case "Pendiente":
        return ["Finalizado", "Cancelado", "Cerrado"];
      case "En-proceso":
        return ["Finalizado", "Cancelado"];
      case "Cancelado":
        return ["Reprogramada"];
      case "Finalizado":
      case "Cerrado":
      case "Reprogramada":
        return [];
      default:
        return [];
    }
  }