part of 'purchases_bloc.dart';

abstract class PurchasesEvent extends Equatable {
  const PurchasesEvent();
}

class FetchPurchasesEvent extends PurchasesEvent {
  const FetchPurchasesEvent({this.purchases});

  final List<PurchaseDetails> purchases;

  @override
  List<Object> get props => [purchases];
}

class FetchProductsEvent extends PurchasesEvent {
  const FetchProductsEvent({this.products});

  final List<ProductDetails> products;

  @override
  List<Object> get props => [products];
}

class PurchaseMonthlyEvent extends PurchasesEvent {
  const PurchaseMonthlyEvent({this.response});

  final bool response;

  @override
  List<Object> get props => [response];
}

class PurchaseAnnualEvent extends PurchasesEvent {
  const PurchaseAnnualEvent({this.response});

  final bool response;

  @override
  List<Object> get props => [response];
}

class RestorePurchasesEvent extends PurchasesEvent {
  const RestorePurchasesEvent({this.isRestored});

  final bool isRestored;

  @override
  List<Object> get props => [isRestored];
}
