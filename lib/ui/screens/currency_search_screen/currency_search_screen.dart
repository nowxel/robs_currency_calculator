import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/i18n/app_localization.dart';
import 'package:robs_currency_calculator/models/currencies.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/currency_search_screen/actions/currency_search_actions.dart';
import 'package:robs_currency_calculator/ui/screens/currency_search_screen/widgets/currencies_list_widget.dart';
import 'package:robs_currency_calculator/ui/screens/currency_search_screen/widgets/search_panel_widget.dart';
import 'package:robs_currency_calculator/ui/screens/currency_search_screen/widgets/title_widget.dart';

class CurrencySearchScreen extends StatefulWidget with RobsCalculatorActions, CurrencySearchActions {

  @override
  _CurrencySearchScreenState createState() => _CurrencySearchScreenState();
}

class _CurrencySearchScreenState extends State<CurrencySearchScreen> {
  Currencies descriptions;
  bool currenciesHasLoaded;
  Currencies searchDescriptionsResult;
  String searchPattern = '';
  ModalRoute<Object> _route;
  List<Object> _args;
  int _buttonNumber;

  @override
  void initState() {
    widget.fetchCurrenciesDescriptions(context: context);
    currenciesHasLoaded = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _route = ModalRoute.of(context);
    _args = _route.settings.arguments as List<Object>;
    _buttonNumber = _args[0] as int;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context).translate;
    return BlocBuilder<CurrenciesBloc, CurrenciesState>(
        builder: (context, state) {
      if (state is FetchCurrenciesDescriptionState) {
        descriptions = state?.currencies;
        currenciesHasLoaded = true;
      } else if (state is SearchCurrenciesState) {
        searchDescriptionsResult = state?.currencies;
        searchPattern = state?.searchPattern;
        currenciesHasLoaded = true;
      }
      return currenciesHasLoaded
          ? Scaffold(
              backgroundColor: accentGray,
              body: Column(
                  children: [
                    TitleWidget(title: translate('SEARCH_CURRENCY')),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    SearchInputFieldWidget(
                      onSearch: (String value){
                        widget.searchCurrencies(context: context,
                            currencies: descriptions, searchPattern: value);
                      },
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    CurrenciesListWidget(descriptions: (searchPattern != null &&
                        searchPattern.isNotEmpty)
                        ? searchDescriptionsResult
                        : descriptions,
                      buttonNumber: _buttonNumber,
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                  ],
                ),
            )
          : const Scaffold(
              body:
                  Center(child: CircularProgressIndicator())
      );
    });
  }
}
