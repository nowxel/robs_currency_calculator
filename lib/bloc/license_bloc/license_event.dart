part of 'license_bloc.dart';

abstract class LicenseEvent extends Equatable {
  const LicenseEvent();
  @override
  List<Object> get props => [];
}

class CheckLicense extends LicenseEvent{
  @override
  List<Object> get props => [];
}

class CheckFirstStart extends LicenseEvent{
  @override
  List<Object> get props => [];
}