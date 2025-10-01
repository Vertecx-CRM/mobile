import 'package:vertecx/data/models/services/service_model.dart';

final List<ServiceModel> mockServices = [
  ServiceModel(
    id: "1",
    name: "Seguridad y Monitoreo",
    image: "assets/imgs/servimg1.png",
    type: ServiceType.instalacion,
  ),
  ServiceModel(
    id: "2",
    name: "Redes Estructuradas",
    image: "assets/imgs/servimg2.png",
    type: ServiceType.instalacion,
  ),
  ServiceModel(
    id: "3",
    name: "Reparación de equipos",
    image: "assets/imgs/servimg3.png",
    type: ServiceType.mantenimientoCorrectivo,
  ),
  ServiceModel(
    id: "4",
    name: "Mantenimiento y soporte Técnico",
    image: "assets/imgs/servimg4.png",
    type: ServiceType.mantenimientoCorrectivo,
  ),
];
