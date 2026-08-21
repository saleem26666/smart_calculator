import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'currency_converter_screen.dart';
import 'tool_screens.dart';
import 'unit_converter_screen.dart';

class ToolsHubScreen extends StatelessWidget {
  const ToolsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = <_Tool>[
      _Tool(
        'Live Currency',
        'Real-time FX rates + offline cache',
        Icons.currency_exchange_rounded,
        () => const CurrencyConverterScreen(),
      ),
      _Tool(
        'Tip & Split',
        'Restaurant tip + bill split',
        Icons.receipt_long_rounded,
        () => const TipSplitScreen(),
      ),
      _Tool(
        'Discount / Markup',
        'Sale price & profit markup',
        Icons.local_offer_rounded,
        () => const DiscountScreen(),
      ),
      _Tool(
        'Loan EMI',
        'Monthly payment & interest',
        Icons.account_balance_rounded,
        () => const EmiScreen(),
      ),
      _Tool(
        'Unit Converter',
        'Length, weight, temperature',
        Icons.swap_horiz_rounded,
        () => const UnitConverterScreen(),
      ),
      _Tool(
        'BMI',
        'Body mass index estimate',
        Icons.monitor_weight_rounded,
        () => const BmiScreen(),
      ),
      _Tool(
        'Fuel Cost',
        'Trip cost from km/L + price',
        Icons.local_gas_station_rounded,
        () => const FuelScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            'More than a calculator',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Everyday money, health, and unit tools — fast and offline.',
            style: GoogleFonts.dmSans(color: AppColors.textMuted),
          ),
          const SizedBox(height: 18),
          ...tools.map((t) => _ToolTile(tool: t)),
        ],
      ),
    );
  }
}

class _Tool {
  _Tool(this.title, this.subtitle, this.icon, this.builder);
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() builder;
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.tool});
  final _Tool tool;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => tool.builder()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(tool.icon, color: AppColors.accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        tool.subtitle,
                        style: GoogleFonts.dmSans(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
