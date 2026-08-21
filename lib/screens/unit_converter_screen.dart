import 'package:flutter/material.dart';

import '../services/calc_engine.dart';
import '../widgets/common_widgets.dart';

enum UnitKind { length, weight, temperature }

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  UnitKind _kind = UnitKind.length;
  final _input = TextEditingController(text: '1');
  late String _from;
  late String _to;

  static const lengthUnits = {
    'm': 1.0,
    'km': 1000.0,
    'cm': 0.01,
    'mm': 0.001,
    'mi': 1609.344,
    'yd': 0.9144,
    'ft': 0.3048,
    'in': 0.0254,
  };

  static const weightUnits = {
    'kg': 1.0,
    'g': 0.001,
    'mg': 0.000001,
    'lb': 0.45359237,
    'oz': 0.028349523125,
    't': 1000.0,
  };

  @override
  void initState() {
    super.initState();
    _resetUnits();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _resetUnits() {
    switch (_kind) {
      case UnitKind.length:
        _from = 'm';
        _to = 'ft';
      case UnitKind.weight:
        _from = 'kg';
        _to = 'lb';
      case UnitKind.temperature:
        _from = 'C';
        _to = 'F';
    }
  }

  Map<String, double> get _map {
    switch (_kind) {
      case UnitKind.length:
        return lengthUnits;
      case UnitKind.weight:
        return weightUnits;
      case UnitKind.temperature:
        return const {'C': 1, 'F': 1, 'K': 1};
    }
  }

  double _convert(double value) {
    if (_kind == UnitKind.temperature) {
      return _convertTemp(value, _from, _to);
    }
    final map = _map;
    final base = value * map[_from]!;
    return base / map[_to]!;
  }

  double _convertTemp(double v, String from, String to) {
    double c;
    switch (from) {
      case 'F':
        c = (v - 32) * 5 / 9;
      case 'K':
        c = v - 273.15;
      default:
        c = v;
    }
    switch (to) {
      case 'F':
        return c * 9 / 5 + 32;
      case 'K':
        return c + 273.15;
      default:
        return c;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = double.tryParse(_input.text) ?? 0;
    final out = _convert(value);
    final units = _map.keys.toList();

    return ToolScaffold(
      title: 'Unit Converter',
      child: Column(
        children: [
          SegmentedButton<UnitKind>(
            segments: const [
              ButtonSegment(value: UnitKind.length, label: Text('Length')),
              ButtonSegment(value: UnitKind.weight, label: Text('Weight')),
              ButtonSegment(value: UnitKind.temperature, label: Text('Temp')),
            ],
            selected: {_kind},
            onSelectionChanged: (s) {
              setState(() {
                _kind = s.first;
                _resetUnits();
              });
            },
          ),
          const SizedBox(height: 16),
          NumberField(
            label: 'Value',
            controller: _input,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: _from,
                  decoration: const InputDecoration(labelText: 'From'),
                  items: units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) => setState(() => _from = v ?? _from),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: _to,
                  decoration: const InputDecoration(labelText: 'To'),
                  items: units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) => setState(() => _to = v ?? _to),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ResultCard(
            label: 'Result',
            value: '${CalcEngine.format(out, maxDecimals: 6)} $_to',
          ),
        ],
      ),
    );
  }
}
