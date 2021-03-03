part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {}


class FetchSettingsState extends SettingsState {
  const FetchSettingsState({this.settings});

  final SettingsModel settings;

  List<Object> get props => [settings];
}