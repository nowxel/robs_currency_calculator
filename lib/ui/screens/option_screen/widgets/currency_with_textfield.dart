import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/models/currency.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/navigation/screens.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/utils/resources.dart';

class CurrencyWithTextField extends StatefulWidget with RobsCalculatorActions {
  CurrencyWithTextField(
      {Key key,
      this.buttonNumber,
      this.controller,
      this.selectedCurrency,
      this.textFieldActivated = true,
      this.numTextController})
      : super(key: key);

  final int buttonNumber;
  final TextEditingController controller;
  final Currency selectedCurrency;
  final bool textFieldActivated;
  final int numTextController;

  @override
  _CurrencyWithTextFieldState createState() => _CurrencyWithTextFieldState();
}

class _CurrencyWithTextFieldState extends State<CurrencyWithTextField> {
  List<int> args;
  bool dataHasLoad;

  @override
  void initState() {
    dataHasLoad = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.textFieldActivated &&
        widget.selectedCurrency != null &&
        widget.selectedCurrency.currencyRate.toString().isNotEmpty) {
      widget?.controller?.text =
          widget?.selectedCurrency?.currencyRate?.toString();
    }
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is FetchSettingsState) {
        if (state.settings != null &&
            widget.selectedCurrency != null &&
            widget.selectedCurrency.currencyCode != '') {
          dataHasLoad = true;
        } else {
          dataHasLoad = false;
        }
        return dataHasLoad
            ? Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<SoundsBloc>(context)
                          .add(PlayClickDouble());
                      widget.navigateToScreen(
                          context: context,
                          screenName: Screens.searchCurrency,
                          arguments: widget.buttonNumber);
                    },
                    child: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          color: accentGray,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0))),
                      child: Center(
                          child: AutoSizeText(
                        widget?.selectedCurrency?.currencySign ??
                            defaultCurrencySymbol,
                        style: Theme.of(context).primaryTextTheme.headline1,
                      )),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      color: accentWhite,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: TextField(
                      onChanged: (String i) {
                        BlocProvider.of<SoundsBloc>(context)
                            .add(PlayClickDouble());
                        if (widget.numTextController == 1 && i != '') {
                          state.settings.rate1 = i;
                        } else if (widget.numTextController == 2 && i != '') {
                          state.settings.rate2 = i;
                        } else if (widget.numTextController == 3 && i != '') {
                          state.settings.rate3 = i;
                        } else if (widget.numTextController == 4 && i != '') {
                          state.settings.rate4 = i;
                        }
                      },
                      onTap: () {
                        BlocProvider.of<SoundsBloc>(context)
                            .add(PlayClickDouble());
                      },
                      onSubmitted: (value) {
                        if (widget.numTextController == 1 && value != '') {
                          state.settings.rate1 = value;
                        } else if (widget.numTextController == 2 &&
                            value != '') {
                          state.settings.rate2 = value;
                        } else if (widget.numTextController == 3 &&
                            value != '') {
                          state.settings.rate3 = value;
                        } else if (widget.numTextController == 4 &&
                            value != '') {
                          state.settings.rate4 = value;
                        }
                        widget.controller.text = value;
                        BlocProvider.of<SettingsBloc>(context)
                            .add(ChangeSettingsEvent(state.settings));
                      },
                      controller: widget.controller,
                      enabled: widget.textFieldActivated,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: accentBlack,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: accentBlack,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(),
                      ),
                    ),
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      }
      return Container();
    });
  }
}
