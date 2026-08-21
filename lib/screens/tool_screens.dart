import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/calc_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class TipSplitScreen extends StatefulWidget {
  const TipSplitScreen({super.key});

  @override
  State<TipSplitScreen> createState() => _TipSplitScreenState();
}

class _TipSplitScreenState extends State<TipSplitScreen> {
  final _bill = TextEditingController(text: '50');
  final _tip = TextEditingController(text: '15');
  final _people = TextEditingController(text: '2');

  @override
  void dispose() {
    _bill.dispose();
    _tip.dispose();
    _people.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bill = double.tryParse(_bill.text) ?? 0;
    final tipPct = double.tryParse(_tip.text) ?? 0;
    final people = int.tryParse(_people.text) ?? 1;
    final tip = CalcEngine.tipAmount(bill, tipPct);
    final total = CalcEngine.tipTotal(bill, tipPct);
    final each = CalcEngine.perPerson(total, people);

    return ToolScaffold(
      title: 'Tip & Bill Split',
      child: Column(
        children: [
          NumberField(
            label: 'Bill amount',
            controller: _bill,
            suffix: '\$',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          NumberField(
            label: 'Tip percent',
            controller: _tip,
            suffix: '%',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          NumberField(
            label: 'People',
            controller: _people,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [10, 15, 18, 20, 25]
                .map(
                  (p) => ActionChip(
                    label: Text('$p%'),
                    backgroundColor: tipPct == p
                        ? AppColors.accent.withValues(alpha: 0.25)
                        : AppColors.surfaceHigh,
                    onPressed: () {
                      _tip.text = '$p';
                      setState(() {});
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          ResultCard(
            label: 'Tip',
            value: '\$${CalcEngine.format(tip, maxDecimals: 2)}',
          ),
          const SizedBox(height: 12),
          ResultCard(
            label: 'Total',
            value: '\$${CalcEngine.format(total, maxDecimals: 2)}',
            subtitle:
                'Each person: \$${CalcEngine.format(each, maxDecimals: 2)}',
          ),
        ],
      ),
    );
  }
}

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final _price = TextEditingController(text: '100');
  final _off = TextEditingController(text: '20');
  bool _markup = false;

  @override
  void dispose() {
    _price.dispose();
    _off.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(_price.text) ?? 0;
    final pct = double.tryParse(_off.text) ?? 0;
    final result = _markup
        ? CalcEngine.markupPrice(price, pct)
        : CalcEngine.discountPrice(price, pct);
    final saved = _markup ? result - price : price - result;

    return ToolScaffold(
      title: 'Discount / Markup',
      child: Column(
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Discount')),
              ButtonSegment(value: true, label: Text('Markup')),
            ],
            selected: {_markup},
            onSelectionChanged: (s) => setState(() => _markup = s.first),
          ),
          const SizedBox(height: 16),
          NumberField(
            label: _markup ? 'Cost' : 'Original price',
            controller: _price,
            suffix: '\$',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          NumberField(
            label: _markup ? 'Markup %' : 'Off %',
            controller: _off,
            suffix: '%',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          ResultCard(
            label: _markup ? 'Selling price' : 'Final price',
            value: '\$${CalcEngine.format(result, maxDecimals: 2)}',
            subtitle: _markup
                ? 'Profit: \$${CalcEngine.format(saved, maxDecimals: 2)}'
                : 'You save: \$${CalcEngine.format(saved, maxDecimals: 2)}',
          ),
        ],
      ),
    );
  }
}

class EmiScreen extends StatefulWidget {
  const EmiScreen({super.key});

  @override
  State<EmiScreen> createState() => _EmiScreenState();
}

class _EmiScreenState extends State<EmiScreen> {
  final _principal = TextEditingController(text: '10000');
  final _rate = TextEditingController(text: '8.5');
  final _months = TextEditingController(text: '36');

  @override
  void dispose() {
    _principal.dispose();
    _rate.dispose();
    _months.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = double.tryParse(_principal.text) ?? 0;
    final r = double.tryParse(_rate.text) ?? 0;
    final n = int.tryParse(_months.text) ?? 0;
    final emi = CalcEngine.emi(principal: p, annualRatePercent: r, months: n);
    final total = emi * n;
    final interest = total - p;

    return ToolScaffold(
      title: 'Loan EMI',
      child: Column(
        children: [
          NumberField(
            label: 'Loan amount',
            controller: _principal,
            suffix: '\$',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          NumberField(
            label: 'Annual interest',
            controller: _rate,
            suffix: '%',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          NumberField(
            label: 'Tenure (months)',
            controller: _months,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          ResultCard(
            label: 'Monthly EMI',
            value: '\$${CalcEngine.format(emi, maxDecimals: 2)}',
          ),
          const SizedBox(height: 12),
          ResultCard(
            label: 'Total payable',
            value: '\$${CalcEngine.format(total, maxDecimals: 2)}',
            subtitle:
                'Interest: \$${CalcEngine.format(interest, maxDecimals: 2)}',
          ),
        ],
      ),
    );
  }
}

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _kg = TextEditingController(text: '70');
  final _cm = TextEditingController(text: '175');

  @override
  void dispose() {
    _kg.dispose();
    _cm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kg = double.tryParse(_kg.text) ?? 0;
    final cm = double.tryParse(_cm.text) ?? 0;
    final bmi = CalcEngine.bmi(kg, cm);

    return ToolScaffold(
      title: 'BMI Calculator',
      child: Column(
        children: [
          NumberField(
            label: 'Weight',
            controller: _kg,
            suffix: 'kg',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          NumberField(
            label: 'Height',
            controller: _cm,
            suffix: 'cm',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          ResultCard(
            label: 'Your BMI',
            value: CalcEngine.format(bmi, maxDecimals: 1),
            subtitle: CalcEngine.bmiCategory(bmi),
          ),
          const SizedBox(height: 12),
          Text(
            'Educational estimate only — not medical advice.',
            style: GoogleFonts.dmSans(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  final _distance = TextEditingController(text: '120');
  final _efficiency = TextEditingController(text: '12');
  final _price = TextEditingController(text: '1.20');

  @override
  void dispose() {
    _distance.dispose();
    _efficiency.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = double.tryParse(_distance.text) ?? 0;
    final e = double.tryParse(_efficiency.text) ?? 0;
    final p = double.tryParse(_price.text) ?? 0;
    final cost = CalcEngine.fuelCost(
      distance: d,
      efficiency: e,
      pricePerUnit: p,
    );
    final used = e <= 0 ? 0.0 : d / e;

    return ToolScaffold(
      title: 'Fuel Cost',
      child: Column(
        children: [
          NumberField(
            label: 'Distance',
            controller: _distance,
            suffix: 'km',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          NumberField(
            label: 'Efficiency',
            controller: _efficiency,
            suffix: 'km/L',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          NumberField(
            label: 'Fuel price',
            controller: _price,
            suffix: '\$/L',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          ResultCard(
            label: 'Trip fuel cost',
            value: '\$${CalcEngine.format(cost, maxDecimals: 2)}',
            subtitle: 'Fuel used: ${CalcEngine.format(used, maxDecimals: 2)} L',
          ),
        ],
      ),
    );
  }
}
