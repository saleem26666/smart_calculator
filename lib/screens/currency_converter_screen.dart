import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/calc_engine.dart';
import '../services/currency_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _amount = TextEditingController(text: '100');
  String _from = 'USD';
  String _to = 'PKR';
  CurrencyRates? _rates;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rates = await CurrencyService.instance.fetchRates(_from);
      if (!mounted) return;
      setState(() {
        _rates = rates;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Could not load live rates. Check internet and try Refresh.';
      });
    }
  }

  Future<void> _onFromChanged(String? code) async {
    if (code == null) return;
    setState(() => _from = code);
    await _load();
  }

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(_amount.text) ?? 0;
    double? result;
    double? unitRate;
    if (_rates != null) {
      try {
        result = CurrencyService.instance.convert(
          amount: amount,
          from: _from,
          to: _to,
          ratesWithBase: _rates!.rates,
          base: _rates!.base,
        );
        unitRate = CurrencyService.instance.convert(
          amount: 1,
          from: _from,
          to: _to,
          ratesWithBase: _rates!.rates,
          base: _rates!.base,
        );
      } catch (_) {
        result = null;
      }
    }

    final codes = <String>{
      ...CurrencyService.popular,
      if (_rates != null) ..._rates!.rates.keys,
    }.toList()
      ..sort();

    return ToolScaffold(
      title: 'Live Currency',
      actions: [
        IconButton(
          tooltip: 'Refresh rates',
          onPressed: _loading ? null : _load,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live exchange rates · offline cache fallback',
            style: GoogleFonts.dmSans(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          NumberField(
            label: 'Amount',
            controller: _amount,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: codes.contains(_from) ? _from : 'USD',
                  decoration: const InputDecoration(labelText: 'From'),
                  items: codes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: _loading ? null : _onFromChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: IconButton.filledTonal(
                  onPressed: _loading ? null : _swap,
                  icon: const Icon(Icons.swap_horiz_rounded),
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: codes.contains(_to) ? _to : 'EUR',
                  decoration: const InputDecoration(labelText: 'To'),
                  items: codes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _to = v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
              ),
              child: Text(
                _error!,
                style: GoogleFonts.dmSans(color: AppColors.text),
              ),
            )
          else if (result != null) ...[
            ResultCard(
              label: 'Converted amount',
              value: '${CalcEngine.format(result, maxDecimals: 4)} $_to',
              subtitle: unitRate == null
                  ? null
                  : '1 $_from = ${CalcEngine.format(unitRate, maxDecimals: 6)} $_to',
            ),
            const SizedBox(height: 12),
            Text(
              _rates!.fromCache
                  ? 'Cached rates · ${_rates!.date}'
                  : 'Live rates · ${_rates!.date}',
              style: GoogleFonts.dmSans(
                color: _rates!.fromCache ? AppColors.warn : AppColors.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rates via open.er-api.com (informational, not for banking).',
              style: GoogleFonts.dmSans(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Quick pairs',
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final pair in const [
                ('USD', 'PKR'),
                ('EUR', 'USD'),
                ('GBP', 'USD'),
                ('USD', 'AED'),
                ('USD', 'INR'),
                ('SAR', 'PKR'),
              ])
                ActionChip(
                  label: Text('${pair.$1} → ${pair.$2}'),
                  backgroundColor: AppColors.surfaceHigh,
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() {
                            _from = pair.$1;
                            _to = pair.$2;
                          });
                          await _load();
                        },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
