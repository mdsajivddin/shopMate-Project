import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ShopMate Exact Color Palette from Live Web App
  static const Color primaryColor = Color(0xFF4A5D4E); // Brand Sage Olive Green
  static const Color primaryDark = Color(0xFF313F34); // Brand Dark Green
  static const Color primaryLight = Color(0xFFE5ECE7); // Brand Light Green Tint
  static const Color primaryBorder = Color(0xFFCCDCD0); // Brand Subtle Border
  static const Color backgroundColor = Color(0xFFFAF8F5); // Warm Luxury Ivory Background
  static const Color cardColor = Colors.white; // Pure White Card Surface
  static const Color textPrimary = Color(0xFF1A211C); // Neutral 900 Heading/Body
  static const Color textSecondary = Color(0xFF71717A); // Neutral 500 Muted Text
  static const Color textMuted = Color(0xFFA1A1AA); // Neutral 400
  static const Color borderColor = Color(0xFFE5E7EB); // Neutral 200 Border
  static const Color borderWarm = Color(0xFFDFD5C5); // Warm Tan Border
  static const Color accentPink = Color(0xFFFF3F6C); // Deal / Badge Accent Pink
  static const Color accentAmber = Color(0xFFF59E0B); // Rating Stars / Warning Amber
  static const Color earthBrown = Color(0xFF533D2D); // Warm Earth Brown
  static const Color earthSand = Color(0xFFD4A373); // Warm Sand Leather
  static const Color errorColor = Color(0xFFDC2626); // Error Red
  static const Color successColor = Color(0xFF10B981); // Emerald 500

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentAmber,
        surface: cardColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32.sp,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: -0.8,
          height: 1.15,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 26.sp,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.6,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.outfit(
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.outfit(
          color: textPrimary,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: textMuted,
          fontSize: 13.sp,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
    );
  }
}
