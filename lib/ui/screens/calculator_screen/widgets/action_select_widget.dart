import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/models/currency.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/actions/calculator_screen_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/history_widget.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/margin_keyboard_widget.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/page_indicator_widget.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/tax_keyboard_widget.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/vat_keyboard_widget.dart';
import 'package:robs_currency_calculator/utils/common_utils.dart';
import 'package:robs_currency_calculator/utils/resources.dart';
import 'calculator_keyboard_widget.dart';
import 'currency_exchange_keyboard.dart';
import 'history_widget.dart';

//PageView for operation selection pages
class ActionSelectWidget extends StatefulWidget
    with RobsCalculatorActions, CalculatorScreenActions {
  ActionSelectWidget(
      {Key key,
      this.height,
      this.buttonSize,
      this.calcScreenSize,
      this.historyKey})
      : super(key: key);

  final double height;
  final double buttonSize;
  final double calcScreenSize;
  final GlobalKey<HistoryWidgetState> historyKey;

  @override
  _ActionSelectWidgetState createState() => _ActionSelectWidgetState();
}

class _ActionSelectWidgetState extends State<ActionSelectWidget> {
  List<String> customRates;
  List<String> selectedCurrenciesCodes;
  List<Currency> selectedCurrenciesRates;
  List<bool> buttonStatesList = [false, false, false, false];
  bool dataHasLoad;
  int currentPage = 0;
  bool autoLoadRates;

  @override
  void initState() {
    dataHasLoad = false;
    widget.activateButton(context: context);
    selectedCurrenciesCodes = widget.loadCurrenciesFromStorage() ?? defaultSelectedCurrencies;
    widget.fetchSelectedCurrenciesRates(
        context: context, currencyCodes: selectedCurrenciesCodes);
    BlocProvider.of<SettingsBloc>(context).add(FetchSettingsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: accentGray,
            height: widget.height - widget.calcScreenSize,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: widget.height -
                    (widget.height - widget.calcScreenSize) * 0.3,
                child: PageView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => getActionPage(index),
                  onPageChanged: (index) {
                    setState(() {
                      CalculatorKeyboardWidget.calcModel.activeMode = index;
                      currentPage = index;
                    });
                  },
                ),
              ),
              PageIndicatorWidget(
                height: (widget.height - widget.calcScreenSize) * 0.08,
                margin: EdgeInsets.only(
                  top: (widget.height - widget.calcScreenSize) * 0.1,
                  bottom: (widget.height - widget.calcScreenSize) * 0.1,
                ),
                currentPageNumber: currentPage,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget getActionPage(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            height: widget.calcScreenSize * 0.27,
            padding: const EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            child: BlocBuilder<CalculationBloc, CalculationState>(
              builder: (context, state) {
                String showStr = '0';
                if (state is Calculation) {
                  if (index == 0) {
                    showStr = state.model.upperStr;
                  }
                  if (index == 1) {
                    showStr = state.model.upperMarginStr;
                  }
                  if (index == 2){
                    showStr = state.model.upperCurrencyStr;
                  }
                }
                return AutoSizeText(
                  showStr,
                  style: Theme.of(context).primaryTextTheme.headline4.copyWith(color: dirtyWhite),
                  minFontSize: 8.0,
                  maxFontSize: 24.0,
                  maxLines: 1,
                );
              },
            )),
        SizedBox(
          height: widget.height * 0.23,
        ),
        Container(
            height: widget.calcScreenSize * 0.27,
            padding: const EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            child: BlocBuilder<CalculationBloc, CalculationState>(
              builder: (context, state) {
                String showStr = '0';
                if (state is Calculation) {
                  showStr = state.model.lowerStr;
                }
                return AutoSizeText(
                  CommonUtils.changeInputStringForUI(showStr),
                  style: Theme.of(context).primaryTextTheme.headline4.copyWith(color: dirtyWhite),
                  minFontSize: 8.0,
                  maxFontSize: 24.0,
                  maxLines: 1,
                );
              },
            )),
        SizedBox(
          height: (widget.height - widget.calcScreenSize) * 0.2,
        ),
        if (index == 0)
          BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
            if (state is FetchSettingsState) {
              dataHasLoad = false;
              selectedCurrenciesCodes = [
                state.settings.currency1,
                state.settings.currency2,
                state.settings.currency3,
                state.settings.currency4
              ];
              customRates = [
                state.settings.rate1,
                state.settings.rate2,
                state.settings.rate3,
                state.settings.rate4
              ];
              autoLoadRates = state.settings.isSwitched4;
              widget.fetchSelectedCurrenciesRates(
                  context: context, currencyCodes: selectedCurrenciesCodes);
              if (selectedCurrenciesCodes != null && selectedCurrenciesCodes.isNotEmpty){
                dataHasLoad = true;
              } else {
                dataHasLoad = false;
              }
              if (state.settings.sharedValue == 0) {
                return dataHasLoad ? VatKeyboardWidget(buttonSize: widget.buttonSize)
                : const Center(child: CircularProgressIndicator(),);
              }
              if (state.settings.sharedValue == 1) {
                return dataHasLoad ? TaxKeyboardWidget(buttonSize: widget.buttonSize)
                : const Center(child: CircularProgressIndicator(),);
              }
            }
            return Container();
          }),
        if (index == 1)
          MarginKeyboardWidget(
            buttonSize: widget.buttonSize,
            historyKey: widget.historyKey,
          ),
        if (index == 2)
          BlocBuilder<CurrenciesBloc, CurrenciesState>(
              builder: (context, state) {
            if (state is FetchCurrenciesRatesState) {
              dataHasLoad = false;
              final Currencies currencies = state?.currencies;
              selectedCurrenciesRates = widget.fetchSelectedCurrencies(
                  currencies: currencies,
                  selectedCurrenciesCodes: selectedCurrenciesCodes);
              if(currencies != null && selectedCurrenciesRates != null &&
                  selectedCurrenciesRates.isNotEmpty){
                dataHasLoad = true;
              } else {
                dataHasLoad = false;
              }
            }
            final Map<String, String> signRate = {
              selectedCurrenciesRates[0].currencySign: autoLoadRates ? selectedCurrenciesRates[0].currencyRate.toString() : customRates[0],
              selectedCurrenciesRates[1].currencySign: autoLoadRates ? selectedCurrenciesRates[1].currencyRate.toString() : customRates[1],
              selectedCurrenciesRates[2].currencySign: autoLoadRates ? selectedCurrenciesRates[2].currencyRate.toString() : customRates[2],
              selectedCurrenciesRates[3].currencySign: autoLoadRates ? selectedCurrenciesRates[3].currencyRate.toString() : customRates[3]
            };
            BlocProvider.of<CalculationBloc>(context).currentModel.signRate = signRate;
            return BlocBuilder<CurrenciesButtonsBloc, CurrenciesButtonsState>(
                builder: (context, state) {
              if (state is SetButtonState) {
                dataHasLoad = false;
                buttonStatesList = state.buttonStateList;
                if (buttonStatesList != null && buttonStatesList.isNotEmpty){
                  dataHasLoad = true;
                } else {
                  dataHasLoad = false;
                }
              }
              return dataHasLoad ? CurrencyExchangeKeyboard(
                  selectedCurrenciesRates: selectedCurrenciesRates,
                  buttonSize: widget.buttonSize,
                  buttonStatesList: buttonStatesList,
                  historyKey: widget.historyKey) : const Center(child: CircularProgressIndicator(),);
            });
          }),
      ],
    );
  }
}
