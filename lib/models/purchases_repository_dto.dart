import 'package:in_app_purchase/in_app_purchase.dart';

class PurchasesRepositoryDTO {
/*
  PurchasesRepositoryDTO(
      this._notFoundIds,
      this._products,
      this._purchases,
      this._consumables,
      this._isAvailable,
      this._purchasePending,
      this._loading,
      this._queryProductError
      );
*/
  List<String> notFoundIds = [];
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  List<String> consumables = [];
  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = true;
  String queryProductError = null;

  /*
  @override
  String toString() {
    return "notFoundIds: " + notFoundIds.toString() + ", products: " + products.toString() + ", purchases: " + purchases.toString() + ", consumables: " + consumables.toString() + ", isAvailable: "  + isAvailable.toString() + ", purchasePending: " + purchasePending.toString()  + ", loading: " + loading.toString() + ", queryProductError: " + queryProductError;
  }
  */
}
