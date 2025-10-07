import 'package:flutter/material.dart';
import 'brand.dart';

/// UAGro App Theme Configuration
class AppTheme {
  AppTheme._();

  /// Light theme for the UAGro Carnet App
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: UAgro.primaryBlue,
        brightness: Brightness.light,
        primary: UAgro.primaryBlue,
        onPrimary: UAgro.textOnPrimary,
        secondary: UAgro.secondaryGold,
        surface: UAgro.white,
        error: UAgro.error,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: UAgro.primaryBlue,
        foregroundColor: UAgro.white,
        elevation: UAgro.elevationMedium,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: UAgro.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: UAgro.white,
        elevation: UAgro.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(UAgro.radiusMedium)),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: UAgro.spacingMedium,
          vertical: UAgro.spacingSmall,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UAgro.primaryBlue,
          foregroundColor: UAgro.white,
          elevation: UAgro.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: UAgro.spacingLarge,
            vertical: UAgro.spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UAgro.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: UAgro.primaryBlue,
          side: const BorderSide(color: UAgro.primaryBlue),
          padding: const EdgeInsets.symmetric(
            horizontal: UAgro.spacingLarge,
            vertical: UAgro.spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UAgro.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: UAgro.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
          borderSide: const BorderSide(color: UAgro.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
          borderSide: const BorderSide(color: UAgro.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
          borderSide: const BorderSide(color: UAgro.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
          borderSide: const BorderSide(color: UAgro.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UAgro.radiusMedium),
          borderSide: const BorderSide(color: UAgro.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UAgro.spacingMedium,
          vertical: UAgro.spacingMedium,
        ),
        labelStyle: const TextStyle(color: UAgro.textSecondary),
        hintStyle: const TextStyle(color: UAgro.textDisabled),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: UAgro.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: UAgro.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: UAgro.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: UAgro.textDisabled,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: UAgro.divider,
        thickness: 1,
        space: UAgro.spacingMedium,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: UAgro.textSecondary,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: UAgro.white,
        size: 24,
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: UAgro.backgroundLight,
    );
  }

  /// Dark theme for the UAGro Carnet App (if needed in the future)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: UAgro.primaryBlue,
        brightness: Brightness.dark,
        primary: UAgro.primaryBlueLight,
        surface: UAgro.backgroundDark,
        error: UAgro.error,
      ),
      scaffoldBackgroundColor: UAgro.backgroundDark,
    );
  }
}