import 'package:math_expressions/math_expressions.dart';

class CalcEngine {
  CalcEngine._();

  static String sanitize(String input) {
    var s = input.trim();
    s = s.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('−', '-');
    s = s.replaceAll('π', 'pi').replaceAll('%', '/100');
    return s;
  }

  /// Evaluate a math expression. Returns null on error.
  static double? evaluate(String expression) {
    try {
      final cleaned = sanitize(expression);
      if (cleaned.isEmpty) return null;
      final parser = GrammarParser();
      final exp = parser.parse(cleaned);
      final cm = ContextModel()
        ..bindVariableName('pi', Number(3.141592653589793))
        ..bindVariableName('e', Number(2.718281828459045));
      final value = RealEvaluator(cm).evaluate(exp);
      final d = value.toDouble();
      if (d.isNaN || d.isInfinite) return null;
      return d;
    } catch (_) {
      return null;
    }
  }

  static String format(double value, {int maxDecimals = 10}) {
    if (value == value.roundToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }
    var s = value.toStringAsFixed(maxDecimals);
    s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return s;
  }

  static double tipAmount(double bill, double tipPercent) =>
      bill * tipPercent / 100;

  static double tipTotal(double bill, double tipPercent) =>
      bill + tipAmount(bill, tipPercent);

  static double perPerson(double total, int people) =>
      people <= 0 ? 0 : total / people;

  static double discountPrice(double price, double percentOff) =>
      price * (1 - percentOff / 100);

  static double markupPrice(double cost, double percent) =>
      cost * (1 + percent / 100);

  /// Standard EMI: P * r * (1+r)^n / ((1+r)^n - 1)
  static double emi({
    required double principal,
    required double annualRatePercent,
    required int months,
  }) {
    if (months <= 0) return 0;
    if (annualRatePercent == 0) return principal / months;
    final r = annualRatePercent / 12 / 100;
    final pow = _pow(1 + r, months);
    return principal * r * pow / (pow - 1);
  }

  static double _pow(double base, int exp) {
    var result = 1.0;
    for (var i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  static double bmi(double weightKg, double heightCm) {
    if (heightCm <= 0) return 0;
    final m = heightCm / 100;
    return weightKg / (m * m);
  }

  static String bmiCategory(double bmi) {
    if (bmi <= 0) return '—';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  static double fuelCost({
    required double distance,
    required double efficiency,
    required double pricePerUnit,
  }) {
    if (efficiency <= 0) return 0;
    return (distance / efficiency) * pricePerUnit;
  }
}
