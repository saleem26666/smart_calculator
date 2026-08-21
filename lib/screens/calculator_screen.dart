import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/calc_engine.dart';
import '../services/history_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, this.scientific = false});

  final bool scientific;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _preview = '0';
  bool _justEvaluated = false;

  void _append(String token) {
    setState(() {
      if (_justEvaluated && RegExp(r'[0-9.]').hasMatch(token)) {
        _expression = token;
        _justEvaluated = false;
      } else {
        if (_justEvaluated && RegExp(r'[+\-×÷*/^]').hasMatch(token)) {
          _justEvaluated = false;
        } else if (_justEvaluated) {
          _expression = '';
          _justEvaluated = false;
        }
        _expression += token;
      }
      _updatePreview();
    });
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _preview = '0';
      return;
    }
    final v = CalcEngine.evaluate(_expression);
    _preview = v == null ? '…' : CalcEngine.format(v);
  }

  void _clear() {
    setState(() {
      _expression = '';
      _preview = '0';
      _justEvaluated = false;
    });
  }

  void _backspace() {
    if (_expression.isEmpty) return;
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
      _justEvaluated = false;
      _updatePreview();
    });
  }

  Future<void> _equals() async {
    final v = CalcEngine.evaluate(_expression);
    if (v == null) {
      setState(() => _preview = 'Error');
      HapticFeedback.heavyImpact();
      return;
    }
    final result = CalcEngine.format(v);
    await HistoryStore.instance.add(
      HistoryItem(
        expression: _expression,
        result: result,
        timestamp: DateTime.now(),
        tag: widget.scientific ? 'scientific' : 'calc',
      ),
    );
    setState(() {
      _expression = result;
      _preview = result;
      _justEvaluated = true;
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleSign() {
    if (_expression.isEmpty) return;
    setState(() {
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else {
        _expression = '-$_expression';
      }
      _updatePreview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rowCount = widget.scientific ? 8 : 5;

    return Column(
      children: [
        Expanded(
          flex: widget.scientific ? 2 : 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.scientific ? 'SCIENTIFIC' : 'STANDARD',
                    style: GoogleFonts.dmSans(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const Spacer(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    _expression.isEmpty ? '0' : _expression,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: widget.scientific ? 18 : 22,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _preview,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: widget.scientific ? 40 : 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: widget.scientific ? 5 : 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final buttonHeight =
                    (constraints.maxHeight / rowCount).clamp(32.0, 58.0);

                Widget row(List<Widget> children) => Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: children,
                      ),
                    );

                Widget btn(
                  String label,
                  VoidCallback onTap, {
                  Color bg = AppColors.number,
                  Color fg = AppColors.text,
                }) {
                  return CalcButton(
                    label: label,
                    onTap: onTap,
                    bg: bg,
                    fg: fg,
                    height: buttonHeight,
                  );
                }

                return Column(
                  children: [
                    if (widget.scientific) ...[
                      row([
                        btn('sin', () => _append('sin('),
                            bg: AppColors.surfaceHigh),
                        btn('cos', () => _append('cos('),
                            bg: AppColors.surfaceHigh),
                        btn('tan', () => _append('tan('),
                            bg: AppColors.surfaceHigh),
                        btn('√', () => _append('sqrt('),
                            bg: AppColors.surfaceHigh),
                      ]),
                      row([
                        btn('ln', () => _append('ln('),
                            bg: AppColors.surfaceHigh),
                        btn('log', () => _append('log('),
                            bg: AppColors.surfaceHigh),
                        btn('π', () => _append('π'),
                            bg: AppColors.surfaceHigh),
                        btn('^', () => _append('^'), bg: AppColors.operator),
                      ]),
                      row([
                        btn('(', () => _append('('),
                            bg: AppColors.surfaceHigh),
                        btn(')', () => _append(')'),
                            bg: AppColors.surfaceHigh),
                        btn('e', () => _append('e'),
                            bg: AppColors.surfaceHigh),
                        btn('abs', () => _append('abs('),
                            bg: AppColors.surfaceHigh),
                      ]),
                    ],
                    row([
                      btn('AC', _clear, bg: AppColors.warn, fg: AppColors.bg),
                      btn('⌫', _backspace, bg: AppColors.operator),
                      btn('%', () => _append('%'), bg: AppColors.operator),
                      btn('÷', () => _append('÷'), bg: AppColors.operator),
                    ]),
                    row([
                      btn('7', () => _append('7')),
                      btn('8', () => _append('8')),
                      btn('9', () => _append('9')),
                      btn('×', () => _append('×'), bg: AppColors.operator),
                    ]),
                    row([
                      btn('4', () => _append('4')),
                      btn('5', () => _append('5')),
                      btn('6', () => _append('6')),
                      btn('−', () => _append('−'), bg: AppColors.operator),
                    ]),
                    row([
                      btn('1', () => _append('1')),
                      btn('2', () => _append('2')),
                      btn('3', () => _append('3')),
                      btn('+', () => _append('+'), bg: AppColors.operator),
                    ]),
                    row([
                      btn('±', _toggleSign, bg: AppColors.surfaceHigh),
                      btn('0', () => _append('0')),
                      btn('.', () => _append('.')),
                      btn('=', () => _equals(),
                          bg: AppColors.accent, fg: AppColors.bg),
                    ]),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
