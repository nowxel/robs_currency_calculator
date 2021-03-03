import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/purchases_bloc/purchases_bloc.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/welcome_screen/actions/welcome_actions.dart';
import 'package:robs_currency_calculator/ui/screens/unlock_screen/widgets/unlock_body_buttons.dart';
import 'package:robs_currency_calculator/widgets/bottom_information.dart';
import 'package:robs_currency_calculator/widgets/title_information.dart';
import 'package:robs_currency_calculator/utils/ShowToastComponent.dart';

class UnlockScreen extends StatefulWidget with WelcomeActions, RobsCalculatorActions {

  UnlockScreen();

  @override
  _UnlockScreenState createState() => _UnlockScreenState();

}

class _UnlockScreenState extends State<UnlockScreen> {

  bool productsHasLoaded = false;

  @override
  void initState() {
    productsHasLoaded = false;
    //widget.fetchPurchases(context: context);
    widget.fetchProducts(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchasesBloc, PurchasesState>(
    builder: (context, state) {
    if (state is FetchProductsState) {
//
//      SchedulerBinding.instance.addPostFrameCallback((_) {
//        ShowToastComponent.showDialog(
//            "FetchProductsState: " + state.toString(), context);
//      });

      productsHasLoaded = true;
//    } else if (state is FetchPurchasesState) {
//
//      SchedulerBinding.instance.addPostFrameCallback((_) {
//        ShowToastComponent.showDialog(
//            "FetchPurchasesState: " + state.toString(), context);
//      });
//      productsHasLoaded = true;
    } else if (state is PurchaseMonthlyState) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
//        ShowToastComponent.showDialog(
//            "PurchaseMonthlyState: " + state.toString(), context);
        widget.navigateCalculatorScreen(context);
      });
    } else if (state is PurchaseAnnualState) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
//        ShowToastComponent.showDialog(
//            "PurchaseAnnualState: " + state.toString(), context);
        widget.navigateCalculatorScreen(context);
      });
    } else if(state is RestorePurchasesState) {
      debugPrint("------ in unlock screen RestorePurchasesState with isRestored=" + state.isRestored.toString());
      if(state.isRestored) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
            widget.navigateCalculatorScreen(context);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ShowToastComponent.showDialog(
              "Issue Restoring Purchases: " + state.toString(), context);
        });
      }
    }
    return productsHasLoaded
      ? Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TitleInformation(title: 'Unlock All Features'),
                UnlockBodyButtons(this.widget),
                BottomInformation()
              ],
            ),
          ),
      )
     :
    const Scaffold(
        body:
         Center(child: CircularProgressIndicator())
    );
    });
  }
}
