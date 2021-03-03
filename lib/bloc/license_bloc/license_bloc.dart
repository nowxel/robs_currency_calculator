import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/services/firebase_service.dart';
import 'package:robs_currency_calculator/utils/device_id.dart';
import 'package:robs_currency_calculator/utils/common_utils.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';

import 'package:flutter/material.dart';

part 'license_event.dart';
part 'license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  LicenseBloc() : super(LicenseInitial());

  static const int trialPeriod = 3;            //days for free use
  IFirebaseService service = FirebaseService();
  bool purchased = false;
  bool trialExpired = false;

  @override
  Stream<LicenseState> mapEventToState(LicenseEvent event) async* {
    debugPrint("--------- LicenseBloc::mapEventToState  event = " + event.toString() +" -------");
    if (event is CheckLicense){
      //trying to get the date of app setup (for current device id) from firebase
      final String setupDate = await service.getSetupDateByDeviceId( await getId());
      debugPrint("--------- setupDate = "+ setupDate + " for state " + event.toString() + "-------");
      if (setupDate.isEmpty){
        //if firebase has no record for current device we create it
        service.addSetupDateByDeviceId(await getId());
      } else {
        final int daysPassed =
          CommonUtils().differenceBetweenNowAndDate(setupDate);
        debugPrint("--------- daysPassed = "+ daysPassed.toString() + "-------");
        //checking setup date, expiring period and purchasing of app
        trialExpired = daysPassed > trialPeriod;
        if(trialExpired){
          debugPrint("--------- trial expited, checking if there is a valid subscription -------");
          purchased = await service.getValidSubscriptionByDeviceId(await getId());
          if(!purchased) {
            yield LicenseExpired();
          } else {
            debugPrint("--------- found valid subscription -------");
          }
        }
      }
    }

    if (event is CheckFirstStart){
      final String firstStarted = await LocalStorage().getFirstStartDate();
      if (firstStarted == null){
        LocalStorage().setFirstStartDate();
        yield StartedFirstTime();
      }
    }
  }
}