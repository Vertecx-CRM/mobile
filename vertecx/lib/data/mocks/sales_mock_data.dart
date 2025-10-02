import 'package:vertecx/data/models/sales/sale_model.dart';

final List<SaleModel> mockSales = [
  SaleModel(
    id: "Ven-001",
    clientName: "Diana Higuita",
    date: DateTime(2025, 7, 11),
    total: 320000,
    status: SaleStatus.finalizado,
  ),
  SaleModel(
    id: "Ven-002",
    clientName: "Juliana Gomez",
    date: DateTime(2025, 7, 23),
    total: 2567000,
    status: SaleStatus.anulado,
  ),
  SaleModel(
    id: "Ven-003",
    clientName: "Melany Perez",
    date: DateTime(2025, 7, 11),
    total: 1245000,
    status: SaleStatus.finalizado,
  ),
  SaleModel(
    id: "Ven-004",
    clientName: "Yisela Urrego",
    date: DateTime(2025, 7, 11),
    total: 245000,
    status: SaleStatus.finalizado,
  ),
  SaleModel(
    id: "Ven-005",
    clientName: "Camila David",
    date: DateTime(2025, 7, 23),
    total: 2567000,
    status: SaleStatus.anulado,
  ),
];
