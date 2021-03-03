import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/utils/common_utils.dart';

abstract class IFirebaseService {
  Future<void> addSetupDateByDeviceId(String id);
  Future<String> getSetupDateByDeviceId(String id);
  Future<bool> getValidSubscriptionByDeviceId(String id);
  Future<void> setValidTillByDeviceId(String id, String date);
}

class FirebaseService extends IFirebaseService{
  FirebaseApp app;

  @override
  Future<void> addSetupDateByDeviceId(String id) async {
    app ??= await Firebase.initializeApp();
    final CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(id)
        .set({'install_date': CommonUtils().getCurrentDate(),})
        .then((value) => debugPrint('Device Added'))
        .catchError((error) => debugPrint('Failed to add device: $error'));
  }

  @override
  Future<String> getSetupDateByDeviceId(String id) async {
    app ??= await Firebase.initializeApp();
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (snapshot.exists) {
      return snapshot.data()['install_date'] as String;
    } else {
      return '';
    }
  }

  @override
  Future<bool> getValidSubscriptionByDeviceId(String id) async {
    app ??= await Firebase.initializeApp();
    final DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (snapshot.exists) {
      String validTill = snapshot.data()['valid_till_date'] as String;
      if(validTill == null) {
        validTill = CommonUtils().getCurrentDate();
      }
      return CommonUtils().differenceBetweenNowAndDate(validTill) >= 0;
    } else {
      return false;
    }
  }

  @override
  Future<void> setValidTillByDeviceId(String id, String date) async {
    debugPrint("--------- setValidTillByDeviceId for date " + date + " --------");
    app ??= await Firebase.initializeApp();
    final CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(id)
        .set({'valid_till_date': date,})
        .then((value) => debugPrint('Subdcription Expiration Date Added'))
        .catchError((error) => debugPrint('Failed to add subscription data: $error'));
  }
}