import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/i18n/app_localization.dart';
import 'package:robs_currency_calculator/theme/theme.dart';
import 'package:robs_currency_calculator/ui/navigation/routes.dart';
import 'package:robs_currency_calculator/ui/navigation/screens.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';
import 'package:flutter/services.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    LocalStorage().getSettings();
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CalculationBloc()),
          BlocProvider(create: (context) => SoundsBloc()),
          BlocProvider(create: (context) => CurrenciesBloc()),
          BlocProvider(create: (context) => CurrenciesButtonsBloc()),
          BlocProvider(create: (context) => LicenseBloc()),
          BlocProvider(create: (context) => SettingsBloc()),
          BlocProvider(create: (context) => PurchasesBloc()),
        ],
        child:
        MaterialApp(
          theme: ThemeStyle.robsCalculatorThemeData,
          initialRoute: getLaunchScreen(),
          routes: appRoutes,
          localizationsDelegates: const [
            LocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (final supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        )
    );
  }

  String getLaunchScreen() {


    return Screens.calculator;
    /*

    bool isFirstLaunch = true;
    //TODO: read isFirstLaunch from SharedPreferences
    if(isFirstLaunch) {
      return Screens.welcomeScreen;
    }

    bool hasValidSubscription = false;
    bool gracePeriodPassed = true;
    //TODO: read purchases detailes from FireBase and app install date
    /* Structure like < get all for user from FireBase

      String code = purchaseDetails.transactionDate;
      String purchaseId = purchaseDetails.purchaseID;
      String productId = purchaseDetails.productID;
      String status = purchaseDetails.status.toString();

      and iterate over them to find out valid

      hasValidSubscription  = PurchasesRepository.isPurchaseValid(code, productId, status);

      X is a number of days for grace period
      calculate if grace period passes (timestamp is a date of app install, from FireBase)

      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      var now = new DateTime.now();
      final difference = now
          .difference(date)
          .inDays;

       gracePeriodPassed = difference < X;
     */
    if(!hasValidSubscription && gracePeriodPassed) {
      return Screens.unlock;
    }
    return Screens.calculator;
     */
  }
}

