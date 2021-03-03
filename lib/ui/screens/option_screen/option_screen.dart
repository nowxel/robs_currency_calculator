import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/i18n/app_localization.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/models/currency.dart';
import 'package:robs_currency_calculator/models/settings_model.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/navigation/screens.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/option_screen/widgets/currency_with_textfield.dart';
import 'package:robs_currency_calculator/ui/screens/option_screen/widgets/rounded_button.dart';
import 'package:robs_currency_calculator/utils/common_utils.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';
import 'package:robs_currency_calculator/widgets/custom_behavior.dart';

class OptionScreen extends StatefulWidget with RobsCalculatorActions {
  @override
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController textEditingController4 = TextEditingController();
  TextEditingController salesTaxRate = TextEditingController();
  List<Currency> selectedCurrenciesRates;
  List<String> selectedCurrenciesCodes;
  Currencies selectedCurrencies;
  Currencies allCurrencies;
  bool textFieldsActivated;
  final LocalStorage _localStorage = LocalStorage();
  bool dataIsLoaded;
  bool autoLoadRates;
  String lastRatesUpdate;
  final CommonUtils _commonUtils = CommonUtils();
  SettingsModel settingsModel = SettingsModel();

  @override
  void initState() {
    BlocProvider.of<SettingsBloc>(context).add(FetchSettingsEvent());
    widget.fetchAllCurrenciesRates(context: context);
    dataIsLoaded = false;
    selectedCurrenciesCodes = widget.loadCurrenciesFromStorage();
    widget.fetchSelectedCurrenciesRates(
        context: context, currencyCodes: selectedCurrenciesCodes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    final Map<int, Widget> logoWidget = <int, Widget>{
      0: Text(translate('VAT'),
          style: Theme.of(context).primaryTextTheme.headline6),
      1: Text(translate('TAX'),
          style: Theme.of(context).primaryTextTheme.headline6),
    };
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is FetchSettingsState) {
        dataIsLoaded = false;
        settingsModel = state.settings;
        autoLoadRates = state.settings.isSwitched4;
        textFieldsActivated = !autoLoadRates;
        if (textFieldsActivated) {
          textEditingController1.text = state.settings.rate1;
          textEditingController2.text = state.settings.rate2;
          textEditingController3.text = state.settings.rate3;
          textEditingController4.text = state.settings.rate4;
        }
        salesTaxRate.text = state.settings.salesTaxRate;
        widget.autoLoadCurrencies(context: context, autoLoad: autoLoadRates);
        selectedCurrenciesCodes = [
          state.settings.currency1,
          state.settings.currency2,
          state.settings.currency3,
          state.settings.currency4
        ];
        widget.fetchSelectedCurrenciesRates(
            context: context, currencyCodes: selectedCurrenciesCodes);

        if (selectedCurrenciesCodes != null &&
            selectedCurrenciesCodes.isNotEmpty) {
          dataIsLoaded = true;
        } else {
          dataIsLoaded = false;
        }
        return dataIsLoaded
            ? Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: accentGray,
                body: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ScrollConfiguration(
                      behavior: CustomBehavior(),
                      child: CustomScrollView(slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                                child: Text(translate('SETTINGS'),
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline1),
                              ),
                              //First String. CupertinoSlidingSegmentedControl
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(translate('SALES_TAX_NAME'),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    child:
                                        CupertinoSlidingSegmentedControl<int>(
                                      children: logoWidget,
                                      onValueChanged: (int value) {
                                        settingsModel.sharedValue = value;
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(ChangeSettingsEvent(
                                                settingsModel));
                                        BlocProvider.of<SoundsBloc>(context)
                                            .add(PlayClickDouble());
                                        setState(() {});
                                      },
                                      thumbColor: accentWhite,
                                      groupValue: settingsModel.sharedValue,
                                    ),
                                  )
                                ],
                              ),
                              //Second String. Input TextField
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 15, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${translate('SALES_TAX_RATE')} %',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline2),
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: accentWhite,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: TextField(
                                        onChanged: (String i) {
                                          BlocProvider.of<SoundsBloc>(context)
                                              .add(PlayClickDouble());
                                        },
                                        onTap: () {
                                          BlocProvider.of<SoundsBloc>(context)
                                              .add(PlayClickDouble());
                                        },
                                        onSubmitted: (value) {
                                          settingsModel.salesTaxRate = value;
                                          BlocProvider.of<SettingsBloc>(context)
                                              .add(ChangeSettingsEvent(
                                                  settingsModel));
                                        },
                                        controller: salesTaxRate,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: accentBlack,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //Third String. remove and add buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${settingsModel.decimalPlaces} ${translate('DP')}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2),
                                  RoundedButton(function: (value) {
                                    setState(() {});
                                  }),
                                ],
                              ),
                              //Four switches
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(translate('FORCE_DP'),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 15, 0),
                                    child: CupertinoSwitch(
                                      value: state
                                          .settings.forceDecimalPlacesEnabled,
                                      onChanged: (value) {
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(ChangeSettingsEvent(
                                                settingsModel));
                                        setState(() {
                                          settingsModel
                                                  .forceDecimalPlacesEnabled =
                                              !settingsModel
                                                  .forceDecimalPlacesEnabled;
                                        });
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(translate('SEPARATOR'),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 15, 0),
                                    child: CupertinoSwitch(
                                      value: settingsModel.separatorEnabled,
                                      onChanged: (value) {
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(ChangeSettingsEvent(
                                                state.settings));
                                        setState(() {
                                          settingsModel.separatorEnabled =
                                              !settingsModel.separatorEnabled;
                                        });
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(translate('SOUNDS'),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 15, 0),
                                    child: CupertinoSwitch(
                                      value: settingsModel.soundsEnabled,
                                      onChanged: (value) {
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(ChangeSettingsEvent(
                                                settingsModel));
                                        setState(() {
                                          settingsModel.soundsEnabled =
                                              !settingsModel.soundsEnabled;
                                        });
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(translate('AUTO_LOAD_RATES'),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 15, 0),
                                    child: CupertinoSwitch(
                                      value: autoLoadRates,
                                      onChanged: (value) {
                                        widget.autoLoadCurrencies(
                                            context: context, autoLoad: value);
                                        settingsModel.isSwitched4 = value;
                                        BlocProvider.of<SettingsBloc>(context)
                                            .add(ChangeSettingsEvent(
                                                settingsModel));
                                        setState(() {
                                          if (value) {
                                            widget.fetchAllCurrenciesRates(
                                                context: context);
                                            widget.fetchSelectedCurrenciesRates(
                                                context: context,
                                                currencyCodes:
                                                    selectedCurrenciesCodes);
                                            textEditingController1.text =
                                                selectedCurrenciesRates[0]
                                                    .currencyRate
                                                    .toString();
                                            textEditingController2.text =
                                                selectedCurrenciesRates[1]
                                                    .currencyRate
                                                    .toString();
                                            textEditingController3.text =
                                                selectedCurrenciesRates[2]
                                                    .currencyRate
                                                    .toString();
                                            textEditingController4.text =
                                                selectedCurrenciesRates[3]
                                                    .currencyRate
                                                    .toString();
                                          } else {
                                            BlocProvider.of<SettingsBloc>(
                                                    context)
                                                .add(ChangeSettingsEvent(
                                                    settingsModel));
                                          }
                                        });
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              // Four container with currency with text field.
                              BlocBuilder<CurrenciesBloc, CurrenciesState>(
                                  builder: (context, state) {
                                if (state is FetchCurrenciesRatesState) {
                                  dataIsLoaded = false;
                                  selectedCurrencies = state?.currencies;
                                  selectedCurrenciesRates =
                                      widget?.fetchSelectedCurrencies(
                                          currencies: selectedCurrencies,
                                          selectedCurrenciesCodes:
                                              selectedCurrenciesCodes);
                                  if (selectedCurrencies != null &&
                                      selectedCurrenciesRates != null &&
                                      selectedCurrenciesRates.isNotEmpty) {
                                    dataIsLoaded = true;
                                    lastRatesUpdate =
                                        _commonUtils.getLastUpdateTime(
                                            state.lastRatesUpdate);
                                  } else {
                                    dataIsLoaded = false;
                                  }
                                } else if (state
                                    is FetchAllCurrenciesRatesState) {
                                  dataIsLoaded = false;
                                  allCurrencies = state.currencies;
                                  if (allCurrencies != null) {
                                    dataIsLoaded = true;
                                  } else {
                                    dataIsLoaded = false;
                                  }
                                } else if (state is SelectCurrencyState) {
                                  dataIsLoaded = false;
                                  final int index = state?.buttonNumber;
                                  if (index != null) {
                                    selectedCurrenciesRates[index] =
                                        widget?.fetchSelectedCurrency(
                                            currencyCode: state?.currencyCode,
                                            currencies: selectedCurrencies);
                                    selectedCurrenciesCodes[index] =
                                        state?.currencyCode;
                                    settingsModel.currency1 =
                                        selectedCurrenciesCodes[0];
                                    settingsModel.currency2 =
                                        selectedCurrenciesCodes[1];
                                    settingsModel.currency3 =
                                        selectedCurrenciesCodes[2];
                                    settingsModel.currency4 =
                                        selectedCurrenciesCodes[3];
                                    BlocProvider.of<SettingsBloc>(context).add(
                                        ChangeSettingsEvent(settingsModel));
                                    _localStorage.saveCurrency(
                                        widget.fetchSelectedCurrenciesCodes(
                                            selectedCurrenciesRates));
                                    lastRatesUpdate =
                                        _commonUtils.getLastUpdateTime(
                                            state.lastRatesUpdate);
                                  }
                                  if (selectedCurrenciesRates != null &&
                                      selectedCurrenciesRates.isNotEmpty &&
                                      selectedCurrenciesCodes != null &&
                                      selectedCurrenciesCodes.isNotEmpty) {
                                    dataIsLoaded = true;
                                  } else {
                                    dataIsLoaded = false;
                                  }
                                } else if (state is AutoLoadCurrencyState) {
                                  dataIsLoaded = false;
                                  textFieldsActivated = !state.autoLoad;
                                  dataIsLoaded = true;
                                }
                                return dataIsLoaded
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CurrencyWithTextField(
                                              numTextController: 1,
                                              textFieldActivated:
                                                  textFieldsActivated,
                                              buttonNumber: 0,
                                              selectedCurrency:
                                                  selectedCurrenciesRates
                                                      ?.elementAt(0),
                                              controller:
                                                  textEditingController1),
                                          CurrencyWithTextField(
                                              numTextController: 2,
                                              textFieldActivated:
                                                  textFieldsActivated,
                                              buttonNumber: 1,
                                              selectedCurrency:
                                                  selectedCurrenciesRates
                                                      ?.elementAt(1),
                                              controller:
                                                  textEditingController2),
                                          CurrencyWithTextField(
                                              numTextController: 3,
                                              textFieldActivated:
                                                  textFieldsActivated,
                                              buttonNumber: 2,
                                              selectedCurrency:
                                                  selectedCurrenciesRates
                                                      ?.elementAt(2),
                                              controller:
                                                  textEditingController3),
                                          CurrencyWithTextField(
                                              numTextController: 4,
                                              textFieldActivated:
                                                  textFieldsActivated,
                                              buttonNumber: 3,
                                              selectedCurrency:
                                                  selectedCurrenciesRates
                                                      ?.elementAt(3),
                                              controller:
                                                  textEditingController4),
                                        ],
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              }),
                              const SizedBox(height: 10),
                              Text(
                                  '${translate('LAST_UPDATE')}: $lastRatesUpdate',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2),
                              const SizedBox(height: 10),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () {
                                          BlocProvider.of<CalculationBloc>(
                                                  context)
                                              .add(const PutFunction(''));
                                          Navigator.popAndPushNamed(
                                              context, Screens.calculator);
                                        }),
//                                    Container(
//                                        padding: const EdgeInsets.fromLTRB(
//                                            0, 0, 10, 0),
//                                        child: Text(translate('MORE_APPS_BY'))),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      }
      return Container();
    });
  }
}
