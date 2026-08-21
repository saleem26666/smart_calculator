import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class CalcButton extends StatelessWidget {
  const CalcButton({
    super.key,
    required this.label,
    required this.onTap,
    this.flex = 1,
    this.bg = AppColors.number,
    this.fg = AppColors.text,
    this.large = false,
    this.height,
  });

  final String label;
  final VoidCallback onTap;
  final int flex;
  final Color bg;
  final Color fg;
  final bool large;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final h = height ?? (large ? 64.0 : 58.0);
    final compact = h < 46;
    final fontSize = compact
        ? (label.length > 2 ? 13.0 : 16.0)
        : (label.length > 2 ? 18.0 : 24.0);
    final radius = compact ? 12.0 : 18.0;
    final fill = height != null;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(compact ? 3 : 5),
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            borderRadius: BorderRadius.circular(radius),
            child: fill
                ? Center(
                    child: Text(
                      label,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  )
                : SizedBox(
                    height: h,
                    child: Center(
                      child: Text(
                        label,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ToolScaffold extends StatelessWidget {
  const ToolScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: child,
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF163528), Color(0xFF141E2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.accent,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: GoogleFonts.dmSans(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.label,
    required this.controller,
    this.suffix,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? suffix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: GoogleFonts.spaceGrotesk(fontSize: 18, color: AppColors.text),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
      ),
    );
  }
}
