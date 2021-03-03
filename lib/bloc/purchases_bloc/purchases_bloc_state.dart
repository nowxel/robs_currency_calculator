part of 'purchases_bloc.dart';

abstract class PurchasesState extends Equatable {
  const PurchasesState();
}

class FetchPurchasesState extends PurchasesState {

  const FetchPurchasesState({this.purchases});
  final List<PurchaseDetails> purchases;

  @override
  List<Object> get props => [purchases];

  @override
  String toString() {

    if(purchases.length == 0) {
      return "Purchases List is empty";
    }

    var str = '';
    for(var i = 0; i < purchases.length; i++) {
      str = str + " , " + purchases[i].purchaseID + " , " + purchases[i].productID + " , " + purchases[i].transactionDate + " , " + purchases[i].status.toString();
    }
    return str;
  }
}

class FetchProductsState extends PurchasesState {

  const FetchProductsState({this.products});
  final List<ProductDetails> products;

  @override
  List<Object> get props => [products];

  @override
  String toString() {

    if(products.length == 0) {
      return "Products List is empty";
    }

    var str = '';
    for(var i = 0; i < products.length; i++) {
      str = str + " , " + products[i].id + " , " + products[i].title + " , " + products[i].description + " , " + products[i].price;
    }
    return str;
  }
}

class PurchaseMonthlyState extends PurchasesState {

  const PurchaseMonthlyState({this.response});
  final Object response;

  @override
  List<Object> get props => [response];

  @override
  String toString() {

    var str = response.toString();

    return str;
  }
}

class PurchaseAnnualState extends PurchasesState {

  const PurchaseAnnualState({this.response});
  final Object response;

  @override
  List<Object> get props => [response];

  @override
  String toString() {

    var str = response.toString();

    return str;
  }
}

class RestorePurchasesState extends PurchasesState {

  const RestorePurchasesState({this.isRestored});
  final bool isRestored;

  @override
  List<Object> get props => [isRestored];

  @override
  String toString() {

    var str = isRestored.toString();

    return str;
  }
}

