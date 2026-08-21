import 'package:flutter_test/flutter_test.dart';
import 'package:smart_calculator/services/calc_engine.dart';

void main() {
  test('basic evaluate', () {
    expect(CalcEngine.evaluate('2+3'), 5);
    expect(CalcEngine.evaluate('10×2'), 20);
    expect(CalcEngine.format(CalcEngine.emi(
      principal: 12000,
      annualRatePercent: 0,
      months: 12,
    )), '1000');
  });

  test('bmi category', () {
    expect(CalcEngine.bmiCategory(22), 'Normal');
  });
}
