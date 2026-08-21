import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Deep ink + mint accent — readable, modern, not generic purple.
class AppColors {
  static const bg = Color(0xFF0B1220);
  static const surface = Color(0xFF141E2E);
  static const surfaceHigh = Color(0xFF1C2A3F);
  static const border = Color(0xFF2A3B55);
  static const text = Color(0xFFF2F6FC);
  static const textMuted = Color(0xFF9AA8BC);
  static const accent = Color(0xFF2EE6A6);
  static const accentDim = Color(0xFF1AAF7C);
  static const warn = Color(0xFFFFB454);
  static const danger = Color(0xFFFF6B7A);
  static const operator = Color(0xFF3D5A80);
  static const number = Color(0xFF243247);
}

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.warn,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.4),
        ),
        labelStyle: const TextStyle(color: AppColors.textMuted),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceHigh,
        contentTextStyle: GoogleFonts.dmSans(color: AppColors.text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
