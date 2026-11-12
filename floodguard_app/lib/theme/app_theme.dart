import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized theme for FloodGuard Malaysia. Every screen picks this up
/// automatically through Theme.of(context) / default Material widget
/// styling, so this single file drives visual consistency across the
/// whole app without needing to edit each screen individually.
class AppTheme {
  // Core brand palette — deep blue/teal evokes water and calm authority,
  // fitting for a flood-safety app without feeling alarming by default.
  static const Color primaryBlue = Color(0xFF0B5FA5);
  static const Color deepNavy = Color(0xFF0A2540);
  static const Color teal = Color(0xFF0E8A82);

  // Risk-level colors, used consistently across Risk Detection, PPS
  // severity, Flood Timeline, and Announcements.
  static const Color riskLow = Color(0xFF2E7D32);
  static const Color riskMedium = Color(0xFFF57C00);
  static const Color riskHigh = Color(0xFFD32F2F);

  static ThemeData get light {
    final base = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base.copyWith(
        primary: primaryBlue,
        secondary: teal,
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F8FB),
      textTheme: _textTheme(base.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF6F8FB),
        foregroundColor: deepNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: deepNavy,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: primaryBlue.withOpacity(0.15),
        labelStyle: GoogleFonts.inter(fontSize: 13, color: deepNavy),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),
    );
  }

  static ThemeData get dark {
    final base = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base.copyWith(
        primary: const Color(0xFF5AA9E6),
        secondary: teal,
      ),
      scaffoldBackgroundColor: deepNavy,
      textTheme: _textTheme(Colors.white).apply(
        bodyColor: Colors.white70,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF13324F),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5AA9E6),
          foregroundColor: deepNavy,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF5AA9E6),
          side: const BorderSide(color: Color(0xFF5AA9E6), width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF13324F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5AA9E6), width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF1E4363), thickness: 1),
    );
  }

  static TextTheme _textTheme(Color baseColor) {
    return TextTheme(
      headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: baseColor),
      headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: baseColor),
      titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: baseColor),
      titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: baseColor),
      bodyLarge: GoogleFonts.inter(color: baseColor),
      bodyMedium: GoogleFonts.inter(color: baseColor),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: baseColor),
    );
  }
}