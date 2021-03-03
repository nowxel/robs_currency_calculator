import 'package:robs_currency_calculator/models/calculation_model.dart';
import 'package:robs_currency_calculator/utils/calculation_utils.dart';

abstract class ICalculationService{
  CalculationModel putNumber(CalculationModel model, int number);
  CalculationModel putAction(CalculationModel model, String action);
  CalculationModel putCurrency(CalculationModel model, String sign, String rate);
}

class CalculationService extends ICalculationService{
  CalculationUtils utils = CalculationUtils();


  @override
  CalculationModel putNumber(CalculationModel model, int number) {
    return utils.addNumber(model, number);
  }

  @override
  CalculationModel putAction(CalculationModel model, String action) {
    return utils.addAction(model, action);
  }

  @override
  CalculationModel putCurrency(CalculationModel model, String sign, String rate) {
    return utils.addCurrency(model, sign, rate);
  }

}