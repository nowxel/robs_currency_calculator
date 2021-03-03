part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class FetchSettingsEvent extends SettingsEvent {
  FetchSettingsEvent();

  List<Object> get props => [];
}

class ChangeSettingsEvent extends SettingsEvent {
  ChangeSettingsEvent(this.settingsModel);

  final SettingsModel settingsModel;

  List<Object> get props => [settingsModel];
}
