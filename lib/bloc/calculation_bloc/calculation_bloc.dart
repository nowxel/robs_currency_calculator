import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robs_currency_calculator/models/calculation_model.dart';
import 'package:robs_currency_calculator/models/history_element_model.dart';
import 'package:robs_currency_calculator/models/settings_model.dart';
import 'package:robs_currency_calculator/services/calculation_service.dart';
import 'package:robs_currency_calculator/utils/local_storage.dart';

part 'calculation_event.dart';

part 'calculation_state.dart';

//Bloc for all current calculations
class CalculationBloc extends Bloc<CalculationEvent, CalculationState> {
  CalculationBloc() : super(CalculationInitial());

  ICalculationService service = CalculationService();
  CalculationModel currentModel = CalculationModel();
  List<HistoryElementModel> history = <HistoryElementModel>[];

  @override
  Stream<CalculationState> mapEventToState(CalculationEvent event) async* {
    if (event is PutNumber) {
      currentModel = service.putNumber(currentModel, event.number);
      yield null;
      yield Calculation(currentModel, history);
    }

    if (event is PutFunction) {
      if (event.action == '=') {
        currentModel.needToClear = true;
      } else {
        currentModel = service.putAction(currentModel, event.action);
      }
      yield null;
      yield Calculation(currentModel, history);
    }

    if (event is PutCurrency) {
      currentModel = service.putCurrency(currentModel, event.sign, event.rate);
      yield null;
      yield Calculation(currentModel, history);
    }

    if (event is GetSettings) {
      final SettingsModel settingsModel = await LocalStorage().getSettings();
      currentModel.upperStr = settingsModel.sharedValue == 0 ? 'VAT = ${settingsModel.salesTaxRate}%' : 'TAX = ${settingsModel.salesTaxRate}%';
      currentModel.vat =
          (Decimal.parse(settingsModel.salesTaxRate) * Decimal.parse('0.01'))
              .toString();
      currentModel.tax =
          (Decimal.parse(settingsModel.salesTaxRate) * Decimal.parse('0.01'))
              .toString();
      yield null;
      yield Calculation(currentModel, history);
    }

    if (event is CalculateMargin) {
      int count = 0;
      currentModel = service.putAction(currentModel, event.action);
      if (currentModel.cost != '') {
        count++;
      }
      if (currentModel.sell != '') {
        count++;
      }
      if (currentModel.margin != '') {
        count++;
      }
      if (count == 2) {
        event.onCalculate(currentModel);
      }

      yield null;
      yield Calculation(currentModel, history);
    }
  }
}
