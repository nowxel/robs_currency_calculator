import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/bloc/bloc.dart';
import 'package:robs_currency_calculator/theme/colors.dart';
import 'package:robs_currency_calculator/ui/screens/actions/robs_calculator_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/actions/calculator_screen_actions.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/calculator_widget.dart';
import 'package:robs_currency_calculator/ui/screens/calculator_screen/widgets/history_widget.dart';

class CalculatorScreen extends StatefulWidget with RobsCalculatorActions {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with CalculatorScreenActions {
  static const int animationSpeed = 300; //milliseconds
  final GlobalKey<HistoryWidgetState> historyKey = GlobalKey<HistoryWidgetState>();
  int _animationDuration ;

  // visual elements dimensions
  double screenHeight;
  double keyboardHeight;
  double calculatorHeight;
  double historyHeight;

  // positions for animation
  double _historyPosition;
  double _calculatorPosition = 0;

  double _historyMaxPosition;
  double _historyMinPosition;
  double _calculatorMaxPosition;

  double _slideStartPosition;
  double _slideCurrentPosition;

  List<String> selectedCurrenciesCodes;

  @override
  void initState() {
    //set screen orientation to portrait only
    setPortraitOrientation();
    //Loading sounds to memory
    BlocProvider.of<SoundsBloc>(context).add(LoadSounds());
    //check setup date, trial period and purchase of app
    BlocProvider.of<LicenseBloc>(context).add(CheckLicense());
    //check for first start of application
    BlocProvider.of<LicenseBloc>(context).add(CheckFirstStart());

    BlocProvider.of<CalculationBloc>(context).add(const GetSettings());
    super.initState();

    selectedCurrenciesCodes = widget.loadCurrenciesFromStorage();
    widget.fetchSelectedCurrenciesRates(context: context, currencyCodes: selectedCurrenciesCodes);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight ??= MediaQuery.of(context).size.height;
    _animationDuration ??= animationSpeed;
    //measures calculations
    calculatorHeight ??= screenHeight * 0.7;
    keyboardHeight ??= calculatorHeight - calculatorHeight / 4.5;
    historyHeight ??= screenHeight - (calculatorHeight - keyboardHeight);

    _historyMaxPosition ??= _historyPosition ??= calculatorHeight;
    _historyMinPosition = calculatorHeight - keyboardHeight;
    _calculatorMaxPosition ??= -keyboardHeight;

    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<SoundsBloc>(context).add(DisposeSounds());
        return Future(() => true);
      },
      child: Scaffold(
        body: Container(
            color: accentGray,
            child: Stack(
              children: [
                //History widget
                AnimatedPositioned(
                  duration: Duration(milliseconds: _animationDuration),
                  bottom: _historyPosition,
                  child: HistoryWidget(
                    key: historyKey,
                    onTap:() => animateStep(),
                    height: historyHeight,
                    historyElementHeight: calculatorHeight / 4.5,
                  ),
                ),
                //Calculator with screen
                AnimatedPositioned(
                  duration: Duration(milliseconds: _animationDuration),
                  bottom: _calculatorPosition,
                  child: GestureDetector(
                    onVerticalDragStart: (_){
                      _animationDuration = 0;
                      _slideStartPosition = _.localPosition.dy;
                    },
                    onVerticalDragUpdate: (_){
                      _slideCurrentPosition = _.localPosition.dy;
                      animateToPosition(_.delta.dy);
                    },
                    onVerticalDragEnd: (_){
                      if(_slideCurrentPosition != null  && _slideStartPosition!= null){
                        _animationDuration = animationSpeed;
                        if (_slideStartPosition - _slideCurrentPosition > _calculatorMaxPosition / 2){
                          animateToBottom();
                        } else {
                          animateToTop();
                        }
                      }
                    },
                    child: CalculatorWidget(
                        height: calculatorHeight,
                        historyKey: historyKey
                    )
                  ),
                ),
                BlocListener<LicenseBloc, LicenseState>(
                  listener: (context, state){
                    debugPrint("-------- calculator screen state: " +state.toString() + " ---------");
                    if (state is LicenseExpired){
                      navigateToUnlock(context);
                    }
                    if (state is StartedFirstTime){
                      navigateToWelcome(context);
                    }
                  },
                  child: Container(),
                ),
              ],
            ),
          )
      ),
    );
  }

  void animateStep(){
    if(_historyPosition == calculatorHeight ){
      animateToTop();
    } else {
      animateToBottom();
    }
  }

  void animateToTop() {
    setState(() {
      _historyPosition = _historyMinPosition;
      _calculatorPosition = _calculatorMaxPosition;
    });
  }

  void animateToBottom(){
    setState(() {
      _historyPosition = _historyMaxPosition;
      _calculatorPosition = 0;
    });
  }

  void animateToPosition(double delta){
    setState(() {
      if (_calculatorPosition - delta < 0
          && _calculatorPosition -delta > _calculatorMaxPosition){
        _calculatorPosition -= delta;
        _historyPosition -= delta;
      }
    });
  }
}
