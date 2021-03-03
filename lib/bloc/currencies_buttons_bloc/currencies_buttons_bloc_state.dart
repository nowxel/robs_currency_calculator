part of 'currencies_buttons_bloc.dart';

abstract class CurrenciesButtonsState extends Equatable {
  const CurrenciesButtonsState();
}

class SetButtonState extends CurrenciesButtonsState {
  const SetButtonState({this.buttonStateList});

  final List<bool> buttonStateList;

  @override
  List<Object> get props => [buttonStateList];
}