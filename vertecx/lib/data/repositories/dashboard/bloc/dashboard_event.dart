abstract class SalesEvent {}

class LoadSalesEvent extends SalesEvent {} 

class LoadMonthlySalesEvent extends SalesEvent {
  final int month;
  LoadMonthlySalesEvent(this.month);
}

abstract class ClientsEvent {}

class LoadClientsEvent extends ClientsEvent {}

class LoadMonthlyClientsEvent extends ClientsEvent {
  final int month;
  LoadMonthlyClientsEvent(this.month);
}

abstract class PurchasesEvent {}

class LoadPurchasesEvent extends PurchasesEvent {}

class LoadMonthlyPurchasesEvent extends PurchasesEvent {
  final int month;
  LoadMonthlyPurchasesEvent(this.month);
}

abstract class AppointmentsEvent {}

class LoadAppointmentsEvent extends AppointmentsEvent {}


abstract class OrdersEvent {}

class LoadOrdersEvent extends OrdersEvent {}

abstract class ProductsEvent {}

class LoadProductsEvent extends ProductsEvent {}






