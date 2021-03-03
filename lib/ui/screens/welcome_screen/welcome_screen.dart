import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/purchases_bloc/purchases_bloc.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/welcome_screen/actions/welcome_actions.dart';
import 'package:robs_currency_calculator/utils/ShowToastComponent.dart';
import 'package:robs_currency_calculator/widgets/bottom_information.dart';
import 'package:robs_currency_calculator/widgets/title_information.dart';

import 'widgets/welcome_body_buttons.dart';

class WelcomeScreen extends StatefulWidget with WelcomeActions, RobsCalculatorActions {

  WelcomeScreen();
  @override
  _WelcomeScreen createState() => _WelcomeScreen();

}

class _WelcomeScreen extends State<WelcomeScreen> {

  bool productsHasLoaded;

  @override
  void initState() {
    productsHasLoaded = false;
    widget.fetchProducts(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchasesBloc, PurchasesState>(
    builder: (context, state) {
      final double displayHeight = MediaQuery
          .of(context)
          .size
          .height;
      final double displayWidth = MediaQuery
          .of(context)
          .size
          .width;

      if(state is RestorePurchasesState) {
        debugPrint("------ in welcome screen RestorePurchasesState with isRestored=" + state.isRestored.toString());
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
      else if (state is FetchProductsState) {
        productsHasLoaded = true;
      }
      return productsHasLoaded
          ? Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TitleInformation(title: 'Welcome to Wedge'),
                WelcomeBodyButtons(this.widget),
                BottomInformation()
              ],
            ),
          ),
      )
          : const Scaffold(
          body:
          Center(child: CircularProgressIndicator())
      );
    });
  }
}
