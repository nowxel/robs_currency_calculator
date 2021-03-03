part of 'currencies_buttons_bloc.dart';

abstract class CurrenciesButtonsEvent extends Equatable {
  const CurrenciesButtonsEvent();
}

class SetButtonEvent extends CurrenciesButtonsEvent {
  const SetButtonEvent({this.index});

  final int index;

  @override
  List<Object> get props => [index];
}