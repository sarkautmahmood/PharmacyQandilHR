import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pharmacy Qandil Brand Colors
  static const Color primaryTeal = Color(0xFF0D9488);
  static const Color primaryDarkTeal = Color(0xFF134E4A);
  static const Color primaryLightTeal = Color(0xFFF0FDFA);
  static const Color accentCyan = Color(0xFF14B8A6);
  static const Color accentMint = Color(0xFF5EEAD4);

  static const Color successGreen = Color(0xFF16A34A);
  static const Color warningOrange = Color(0xFFD97706);
  static const Color dangerRed = Color(0xFFDC2626);

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardSurface = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        secondary: accentCyan,
        background: backgroundLight,
        surface: cardSurface,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.cairoTextTheme().apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDarkTeal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: cardSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
    );
  }
}
