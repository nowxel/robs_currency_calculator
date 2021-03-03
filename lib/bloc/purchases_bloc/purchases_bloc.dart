import 'dart:async';
import 'package:robs_currency_calculator/services/purchase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:equatable/equatable.dart';

part 'purchases_bloc_event.dart';
part 'purchases_bloc_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  PurchasesBloc() : super(null);
  final PurchaseService _purchasesService = PurchaseService();

  @override
  Stream<PurchasesState> mapEventToState(PurchasesEvent event) async* {
    if (event is FetchPurchasesEvent){
      yield FetchPurchasesState(purchases: await _purchasesService?.fetchPurchases());
    } else if (event is FetchProductsEvent){
      yield FetchProductsState(products: await _purchasesService?.fetchProducts());
    } else if (event is PurchaseMonthlyEvent){
      yield PurchaseMonthlyState(response: await _purchasesService?.purchaseMonthlty());
    } else if (event is PurchaseAnnualEvent){
      yield PurchaseAnnualState(response: await _purchasesService?.purchaseAnnual());
    } else if (event is RestorePurchasesEvent){
      yield RestorePurchasesState(isRestored: await _purchasesService?.restorePurchases());
    }
  }
}
