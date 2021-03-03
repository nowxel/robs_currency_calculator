import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'currencies_buttons_bloc_event.dart';

part 'currencies_buttons_bloc_state.dart';

class CurrenciesButtonsBloc extends Bloc<CurrenciesButtonsEvent, CurrenciesButtonsState> {
  CurrenciesButtonsBloc() : super(null);

  @override
  Stream<CurrenciesButtonsState> mapEventToState(
      CurrenciesButtonsEvent event) async* {
    if (event is SetButtonEvent) {
      final List<bool> buttonStateList = [false, false, false, false];
      if (event.index != null && event.index < buttonStateList.length) {
        buttonStateList[event.index] = true;
      }
      yield SetButtonState(buttonStateList: buttonStateList);
    }
  }
}
