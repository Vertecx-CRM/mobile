import 'package:flutter/material.dart';

enum Estado { aprobada, pendiente, anulada }

class RequestModel {
  final int id;
  final String titulo;
  final String tipo;
  final DateTime fecha;
  final Estado estado;

  const RequestModel({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.fecha,
    required this.estado,
  });

  String get estadoLabel {
    switch (estado) {
      case Estado.aprobada: return 'Aprobada';
      case Estado.pendiente: return 'Pendiente';
      case Estado.anulada:   return 'Anulada';
    }
  }

  Color get estadoBg {
    switch (estado) {
      case Estado.aprobada: return const Color(0xFFE9F7EC);
      case Estado.pendiente:return const Color(0xFFFFF4DD);
      case Estado.anulada:  return const Color(0xFFFFE6E6);
    }
  }

  Color get estadoFg {
    switch (estado) {
      case Estado.aprobada: return const Color(0xFF2E7D32);
      case Estado.pendiente:return const Color(0xFF9B6A00);
      case Estado.anulada:  return const Color(0xFFB00020);
    }
  }
}
