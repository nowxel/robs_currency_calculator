import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/bloc/calculation_bloc/calculation_bloc.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/utils/common_utils.dart';

//Main calculator screen widget for display of current operation
class ScreenWidget extends StatelessWidget {
  const ScreenWidget({Key key, this.height, this.screenSize}) : super(key: key);

  final double height;
  final double screenSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 30),
      alignment: Alignment.topRight,
      color: accentBlack,
      height: height,
      child: Container(
        alignment: Alignment.centerRight,
        height: screenSize,
          child: BlocBuilder<CalculationBloc, CalculationState>(
            builder: (context, state){
              String showStr = '0';
              if (state is Calculation){
               // showStr = state.model.strForScreen;
                showStr = CommonUtils.changeResultStringForUI(state.model.strForScreen);
              }
              return AutoSizeText(
                showStr,
                style: Theme.of(context).primaryTextTheme.headline3,
                minFontSize: 10.0,
                maxFontSize: 36.0,
                maxLines: 1,
              );
            },
          )
      ),
    );
  }
}
