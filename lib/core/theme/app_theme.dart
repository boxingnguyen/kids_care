import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kite & String — warm, playful family safety design system.
class AppTheme {
  // ── Primary palette ──────────────────────────────────────────
  static const Color primaryColor = Color(0xFFFF8C00); // amber orange
  static const Color primaryDark = Color(0xFFE67700);
  static const Color primaryLight = Color(0xFFFFF3E0); // warm cream

  // ── Status colours ───────────────────────────────────────────
  static const Color schoolColor = Color(0xFF42A5F5); // blue
  static const Color playColor = Color(0xFF66BB6A); // green
  static const Color homeColor = Color(0xFFFF8C00); // same as primary
  static const Color arrivedColor = Color(0xFFAB47BC); // purple
  static const Color dangerColor = Color(0xFFEF5350); // red

  // ── Surfaces ─────────────────────────────────────────────────
  static const Color backgroundGrey = Color(0xFFFFF8F0); // warm off-white
  static const Color cardColor = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F0E8);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2D2013);
  static const Color textSecondary = Color(0xFF7A6652);
  static const Color textHint = Color(0xFFB0A090);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: primaryColor,
            brightness: Brightness.light,
          ).copyWith(
            primary: primaryColor,
            surface: Colors.white,
            onPrimary: Colors.white,
          ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme),
      scaffoldBackgroundColor: backgroundGrey,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(color: textHint, fontSize: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFFB0A090),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(48, 48),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: textPrimary,
        ),
        contentTextStyle: GoogleFonts.nunito(
          fontSize: 15,
          color: textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: primaryColor,
        minVerticalPadding: 12,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        subtitleTextStyle: GoogleFonts.nunito(
          fontSize: 13,
          color: textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
