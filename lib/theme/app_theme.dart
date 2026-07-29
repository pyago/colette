import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scrapbook / journal theme from Mama's purple-lily letter pages.
class AppColors {
  static const background = Color(0xFF4A2F5C);
  static const backgroundDeep = Color(0xFF2E1A3D);
  static const paper = Color(0xFFFFFCF7);
  static const paperLine = Color(0xFFB7C7E0);
  static const ink = Color(0xFF2C1B3D);
  static const text = Color(0xFF2C1B3D);
  static const muted = Color(0xFF6E5A7C);
  static const accent = Color(0xFF7A4B9A);
  static const accentSoft = Color(0xFFC9A7E0);
  static const heart = Color(0xFF8B4FA8);
  static const softBorder = Color(0xFFE4D4F0);
  static const card = paper;
}

class AppTheme {
  static ThemeData get light {
    final handwriting = GoogleFonts.caveat;
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
        surface: AppColors.paper,
        primary: AppColors.accent,
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F0FA),
    );

    return base.copyWith(
      textTheme: handwritingTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF6F0FA),
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: handwriting(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.softBorder),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: handwriting(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: handwriting(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: handwriting(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.softBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.softBorder),
        ),
      ),
    );
  }

  static TextTheme handwritingTextTheme(TextTheme base) {
    return GoogleFonts.caveatTextTheme(base).copyWith(
      bodyLarge: GoogleFonts.caveat(fontSize: 24, height: 1.35),
      bodyMedium: GoogleFonts.caveat(fontSize: 22, height: 1.35),
      bodySmall: GoogleFonts.caveat(fontSize: 18, height: 1.3),
      titleLarge: GoogleFonts.caveat(fontSize: 34, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.caveat(fontSize: 28, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.caveat(fontSize: 24, fontWeight: FontWeight.w600),
      headlineMedium:
          GoogleFonts.caveat(fontSize: 42, fontWeight: FontWeight.w600),
      headlineSmall:
          GoogleFonts.caveat(fontSize: 34, fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.caveat(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
