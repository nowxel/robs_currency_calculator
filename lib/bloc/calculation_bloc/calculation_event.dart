part of 'calculation_bloc.dart';

abstract class CalculationEvent extends Equatable {
  const CalculationEvent();
  @override
  List<Object> get props => [];
}

class PutNumber extends CalculationEvent{
  const PutNumber(this.number);

  final int number;

  @override
  List<Object> get props => [number];
}

class PutFunction extends CalculationEvent{
  const PutFunction(this.action);

  final String action;

  @override
  List<Object> get props => [action];
}

class PutCurrency extends CalculationEvent{
  const PutCurrency(this.sign, this.rate);

  final String sign;
  final String rate;

  @override
  List<Object> get props => [sign, rate];
}

class PutCurrencyFunction extends CalculationEvent{
  const PutCurrencyFunction(this.currency);

  final String currency;

  @override
  List<Object> get props => [currency];
}


class GetSettings extends CalculationEvent{
const GetSettings();

@override
List<Object> get props => [];
}

class CalculateMargin extends CalculationEvent{
  const CalculateMargin({this.onCalculate, this.action});

  final Function (CalculationModel) onCalculate;
  final String action;

  @override
  List<Object> get props => [onCalculate, action];
}