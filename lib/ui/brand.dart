import 'package:flutter/material.dart';

/// UAGro (Universidad Autónoma de Guerrero) Brand Colors and Constants
class UAgro {
  UAgro._();

  // Primary colors - UAGro institutional blue
  static const Color primaryBlue = Color(0xFF003A7D);
  static const Color primaryBlueLight = Color(0xFF1E5FAF);
  static const Color primaryBlueDark = Color(0xFF002454);

  // Secondary colors
  static const Color secondaryGold = Color(0xFFFFB627);
  static const Color secondaryGoldLight = Color(0xFFFFCC66);
  static const Color secondaryGoldDark = Color(0xFFE69E00);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
  static const Color black = Color(0xFF212121);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF303030);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border and divider colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);

  // University specific
  static const String universityName = 'Universidad Autónoma de Guerrero';
  static const String universityShortName = 'UAGro';
  
  // App specific
  static const String appName = 'Carnet Alumno';
  static const String appVersion = '1.0.0';

  // Spacing constants
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border radius constants
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  // Elevation constants
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}