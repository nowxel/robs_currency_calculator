part of 'calculation_bloc.dart';

abstract class CalculationState extends Equatable {
  @override
  List<Object> get props => [];
}

class CalculationInitial extends CalculationState {
  @override
  List<Object> get props => [];
}

class Calculation extends CalculationState {
  Calculation(this.model, this.history);

  final CalculationModel model;
  final List<HistoryElementModel> history;
  @override
  List<Object> get props => [model];
}
