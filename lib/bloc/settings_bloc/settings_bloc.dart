import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:robs_currency_calculator/models/settings_model.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial());
  LocalStorage cache = LocalStorage();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event,) async* {
    if (event is FetchSettingsEvent) {
      yield FetchSettingsState(settings: await cache.getSettings());
    }

    if (event is ChangeSettingsEvent) {
      await cache.saveSettings(event.settingsModel);
      yield FetchSettingsState(settings: await cache.getSettings());
    }
  }
}
