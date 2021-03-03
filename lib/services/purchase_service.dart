
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:robs_currency_calculator/repositories/purchases_repository.dart';

import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/services/firebase_service.dart';
import 'package:robs_currency_calculator/utils/common_utils.dart';
import 'package:robs_currency_calculator/utils/device_id.dart';

abstract class IPurchaseService {
  Future<List<ProductDetails>> fetchProducts();
  Future<List<PurchaseDetails>> fetchPurchases();
  Future<bool> purchaseMonthlty();
  Future<bool> purchaseAnnual();
  Future<bool> restorePurchases();
}

class PurchaseService extends IPurchaseService {
  final PurchasesRepository _purchasesRepository = PurchasesRepository();
  List<ProductDetails> products;
  List<PurchaseDetails> purchases;

  IFirebaseService fbService = FirebaseService();

  @override
  Future<List<ProductDetails>> fetchProducts() async {
    try {
      final dynamic response = await _purchasesRepository.getProductDetails();
      debugPrint(response.toString());
      final List<ProductDetails> result = response.products as List<ProductDetails>;
      debugPrint("--------------- Products -----------");
      products = result;
      var str = '';
      for(var i = 0; i < result.length; i++) {
        str = str + " , " + result[i].id + " , " + result[i].title + " , " + result[i].description + " , " + result[i].price;
      }

      debugPrint(str);
      return result;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the products data');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PurchaseDetails>> fetchPurchases() async {
    try {
      final dynamic response = await _purchasesRepository.getPurchaseDetails();
      debugPrint(response.toString());
      final List<PurchaseDetails> result = response.purchases  as List<PurchaseDetails>;
      debugPrint("--------------- purchases -----------");
      purchases = result;
      var str = '';
      for(var i = 0; i < result.length; i++) {
        str = str + " , " + result[i].purchaseID + " , " + result[i].productID + " , " + result[i].transactionDate + " , " + result[i].status.toString();
      }

      debugPrint(str);
      return result;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the purchases data');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> purchaseMonthlty() async {
    debugPrint("--------------- purchaseMonthlty -----------");
    try {
      if(products == null || products.isEmpty) {
        final dynamic response = await _purchasesRepository.getProductDetails();
        products = response.products as List<ProductDetails>;

        var str = '';
        for(var i = 0; i < products.length; i++) {
          str = str + " , " + products[i].id + " , " + products[i].title + " , " + products[i].description + " , " + products[i].price;
        }

        debugPrint(str);
      }

      ProductDetails monthlySubscription;

      for(var i = 0; i < products.length; i++) {
        if(products[i].title.toLowerCase().contains('month')) {
          monthlySubscription = products[i];
          break;
        }
      }

      if(monthlySubscription == null) {
        debugPrint("--------------- monthly subscription not found -----------");
        return Future<bool>.value(false);
      }

      await _purchasesRepository.cancellPandingPurchases();

      final PurchaseParam purchaseParam = PurchaseParam(productDetails: monthlySubscription);
      return _purchasesRepository.purchase(purchaseParam);

    } on FormatException catch (_) {
      throw const FormatException('Unable to purchase monthly subscription');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> purchaseAnnual() async {
    debugPrint("--------------- purchaseAnnual -----------");
    try {
      if(products == null || products.isEmpty) {
        final dynamic response = await _purchasesRepository.getProductDetails();
        products = response.products as List<ProductDetails>;
      }

      ProductDetails annualSubscription;

      for(var i = 0; i < products.length; i++) {
        if(products[i].title.toLowerCase().contains('annual')) {
          annualSubscription = products[i];
          break;
        }
      }

      if(annualSubscription == null) {
        debugPrint("--------------- annual subscription not found -----------");
        return Future<bool>.value(false);
      }

      await _purchasesRepository.cancellPandingPurchases();

      final PurchaseParam purchaseParam = PurchaseParam(productDetails: annualSubscription);
      return _purchasesRepository.purchase(purchaseParam);

    } on FormatException catch (_) {
      throw const FormatException('Unable to purchase annual subscription');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> restorePurchases() async {
    debugPrint("--------------- restorePurchases -----------");
    try {
      if(purchases == null || purchases.isEmpty) {
        final dynamic response = await _purchasesRepository.getPurchaseDetails();
        debugPrint(response.toString());
        final List<PurchaseDetails> result = response.purchases as List<PurchaseDetails>;
        debugPrint("--------------- purchases -----------");
        purchases = result;
      }
      if(purchases == null || purchases.isEmpty) {
        debugPrint("--------------- purchases empty, nothing top restore-----------");
        return Future<bool>.value(false);
      }

      for(var i = 0; i < purchases.length; i++) {
        if(PurchasesRepository.isPurchaseValid(
            purchases[i].transactionDate,
            purchases[i].productID,
            purchases[i].status.toString())) {
          fbService.setValidTillByDeviceId(await getId(),
              CommonUtils().getSubscriptionEndDate(purchases[i].transactionDate, purchases[i].productID));
          return  Future<bool>.value(true);
        }
      }
      debugPrint("--------------- not found any valid subscriptions -----------");
      return Future<bool>.value(false);
    } on FormatException catch (_) {
      throw const FormatException('Unable to restore purchases');
    } catch (e) {
      rethrow;
    }
  }
}
