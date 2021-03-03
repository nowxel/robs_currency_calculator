

import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:robs_currency_calculator/services/firebase_service.dart';
import 'package:robs_currency_calculator/utils/common_utils.dart';
import 'package:robs_currency_calculator/utils/consumable_store.dart';
import 'package:robs_currency_calculator/models/purchases_repository_dto.dart';

import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/utils/device_id.dart';

const bool _kAutoConsume = true;

const String _kConsumableId = 'consumable';//if we ever later have it
const List<String> _kProductIds = <String>[
  _kConsumableId,
  //'upgrade',
  //'subscription'
  'pro_annualy', 'pro_monthly',//Android
  'WEDGE_PRO_ANNUAL', 'WEDGE_PRO_MONTHLY'//iOS
];

abstract class IPurchasesRepository {

  void init();

  Future<PurchasesRepositoryDTO> getProductDetails();
  Future<PurchasesRepositoryDTO> getPurchaseDetails();
}

class PurchasesRepository extends IPurchasesRepository {

  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;

  StreamSubscription<List<PurchaseDetails>> _subscription;

  bool initiated = false;

  PurchasesRepositoryDTO state = new PurchasesRepositoryDTO();

  IFirebaseService fbService = FirebaseService();

  @override
  void init() {

    //init store once
    if(initiated) {
      return;
    }
    initStoreInfo();

    initiated = true;
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    debugPrint("------------- initStoreInfo ---------");
    debugPrint(isAvailable.toString());
    if (!isAvailable) {

        state.isAvailable = isAvailable;
        state.products = [];
        state.purchases = [];
        state.notFoundIds = [];
        state.consumables = [];
        state.purchasePending = false;
        state.loading = false;
        state.queryProductError = null;

        return;
    }
    debugPrint("--------------- PurchasesRepository::init -----------");
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList as List<PurchaseDetails>);
    }, onDone: () {
      debugPrint("--------------- PurchasesRepository::init.done -----------");
      _subscription.cancel();// - shall we cancel the subscription once done?
    }, onError: (error) {
      debugPrint("--------------- PurchasesRepository::init.onError -----------");
      debugPrint(error.toString());
      // handle error here.
    })  as StreamSubscription<List<PurchaseDetails>>;
  return;
  }

  @override
  Future<PurchasesRepositoryDTO> getProductDetails() async {
    try {
      init();
      debugPrint("------------- getProductDetails ---------");
      final ProductDetailsResponse productDetailResponse =
      await _connection.queryProductDetails(_kProductIds.toSet());
      if (productDetailResponse.error != null) {
        debugPrint("------------- getProductDetails no error ---------");
        state.queryProductError = productDetailResponse.error.message;
        state.products = productDetailResponse.productDetails;
        state.purchases = [];
        state.notFoundIds = productDetailResponse.notFoundIDs;
        state.consumables = [];
        state.purchasePending = false;
        state.loading = false;

        return state;
      } else if (productDetailResponse.productDetails.isEmpty) {
        debugPrint("------------- getProductDetails empty productDetailResponse.productDetails ---------");
        state.queryProductError = null;
        state.products = productDetailResponse.productDetails;
        state.purchases = [];
        state.notFoundIds = productDetailResponse.notFoundIDs;
        state.consumables = [];
        state.purchasePending = false;
        state.loading = false;

      }

      final QueryPurchaseDetailsResponse purchaseResponse =
      await _connection.queryPastPurchases();
      if (purchaseResponse.error != null) {
        // handle query past purchase error..
      }
      final List<PurchaseDetails> verifiedPurchases = [];
      for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
        if (await _verifyPurchase(purchase)) {
          verifiedPurchases.add(purchase);
        }
      }
      List<String> consumables = await ConsumableStore.load();

      state.products = productDetailResponse.productDetails;
      state.purchases = verifiedPurchases;
      state.notFoundIds = productDetailResponse.notFoundIDs;
      state.consumables = consumables;
      state.purchasePending = false;
      state.loading = false;

      return state;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PurchasesRepositoryDTO> getPurchaseDetails() async {
    try {
      init();
      final QueryPurchaseDetailsResponse purchaseResponse =
      await _connection.queryPastPurchases();
      if (purchaseResponse.error != null) {
        // handle query past purchase error..
      }
      final List<PurchaseDetails> verifiedPurchases = [];
      for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
        if (await _verifyPurchase(purchase)) {
          verifiedPurchases.add(purchase);
        }
      }
      List<String> consumables = await ConsumableStore.load();

      state.purchases = verifiedPurchases;
      state.consumables = consumables;
      state.purchasePending = false;
      state.loading = false;

      return state;

    } catch (e) {
      rethrow;
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    debugPrint("--------------- _listenToPurchaseUpdated -----------");
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {

          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    debugPrint("--------- deliverProduct for purchase " + purchaseDetails.toString() + " --------");
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.load();

      state.purchasePending = false;
      state.consumables = consumables;

    } else {

      state.purchases.add(purchaseDetails);
      state.purchasePending = false;
    }

    fbService.setValidTillByDeviceId(await getId(),
        CommonUtils().getSubscriptionEndDate(purchaseDetails.transactionDate, purchaseDetails.productID));
  }

  Future<void> consume(String id) async {
      await ConsumableStore.consume(id);
      final List<String> consumables = await ConsumableStore.load();
      state.consumables = consumables;
      //TODO: add yelding of an event?
    }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    PurchaseStatus status = purchaseDetails.status;

    if(status != PurchaseStatus.purchased) {
      return Future<bool>.value(false);
    }

    PurchaseVerificationData data = purchaseDetails.verificationData;

    if( (data.localVerificationData == null || data.localVerificationData?.isEmpty ?? true)
        || (data.serverVerificationData == null  || data.serverVerificationData?.isEmpty ?? true)
        || (data.source == null  || data.source.toString()?.isEmpty ?? true)) {
      //smth. wrong with verification data
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  // Use for validation fetched from FireBase - verify if we have lasting subscription
  /*
      String code = purchaseDetails.transactionDate;
      String purchaseId = purchaseDetails.purchaseID;
      String productId = purchaseDetails.productID;
      String status = purchaseDetails.status.toString();
   */
  static bool isPurchaseValid(String code, String productId, String status) {
    if(status == PurchaseStatus.purchased.toString() ) {
      int timestamp = int.parse(code);
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      var now = new DateTime.now();
      final difference = now
          .difference(date)
          .inDays;

      if (productId.toLowerCase().contains(
          'annual')) { //check annual
        if (difference < 365) { //found valid annual subscription
          debugPrint(
              "--------------- found valid annual subscription -----------");
          return true;
        }
      } else if (productId.toLowerCase().contains(
          'month')) { //check monthly
        if (difference < 30) { //found valid month subscription
          debugPrint(
              "--------------- found valid monthly subnscription -----------");
          return true;
        }
      }
    }
    return false;
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.

  }

  void handleError(IAPError error) {
      state.purchasePending = false;
    //TODO: add yelding of an event?
  }

  void showPendingUI() {
      state.purchasePending = true;
    //TODO: add yelding of an event?
  }

  Future<bool> purchase(PurchaseParam purchaseParam) {
    return InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> cancellPandingPurchases() async {
    if(InAppPurchaseConnection.enablePendingPurchase) {
      // figure out how to cancel it https://developer.android.com/google/play/billing/billing_library_overview#pending
      // but in this app it is not enabled so - no worries
    }
  }
}
