//Model for saving calculations
class HistoryElementModel{
  HistoryElementModel(this.upperString, this.calculationsString, this.loverString, this.day, this.month);

  String upperString;
  String calculationsString;
  String loverString;
  String day;
  String month;

  static HistoryElementModel mockModel = HistoryElementModel(
      '',
      'USD18.1212343432',
      'USD18.1212343432',
      '20',
      'NOV'
      );
}