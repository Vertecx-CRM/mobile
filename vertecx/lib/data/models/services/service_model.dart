import 'package:flutter/material.dart';

enum ServiceType {
  instalacion,
  mantenimientoCorrectivo,
  mantenimientoPreventivo,
}

extension ServiceTypeExtension on ServiceType {
  String get name {
    switch (this) {
      case ServiceType.instalacion:
        return "Instalación";
      case ServiceType.mantenimientoCorrectivo:
        return "Mantenimiento Correctivo";
      case ServiceType.mantenimientoPreventivo:
        return "Mantenimiento Preventivo";
    }
  }

  // Para darle color dependiendo del tipo
  Color get color {
    switch (this) {
      case ServiceType.instalacion:
        return Color(0xffC48600);
      case ServiceType.mantenimientoCorrectivo:
        return Color(0xffB20000);
      case ServiceType.mantenimientoPreventivo:
        return Colors.blue;
    }
  }
}

class ServiceModel {
  final String id;
  final String name;
  final String image;
  final ServiceType type;

  ServiceModel({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });
}
