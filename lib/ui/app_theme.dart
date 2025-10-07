// UAGro institutional app theme
// This file contains the official UAGro app theme and styling

import 'package:flutter/material.dart';
import 'brand.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    
    // Color scheme based on UAGro branding
    colorScheme: ColorScheme.fromSeed(
      seedColor: UAGroColors.primary,
      primary: UAGroColors.primary,
      onPrimary: UAGroColors.textOnPrimary,
      secondary: UAGroColors.secondary,
      onSecondary: UAGroColors.textOnPrimary,
      tertiary: UAGroColors.accent,
      onTertiary: UAGroColors.textPrimary,
      surface: UAGroColors.surface,
      onSurface: UAGroColors.textPrimary,
      background: UAGroColors.background,
      onBackground: UAGroColors.textPrimary,
      error: UAGroColors.error,
      onError: UAGroColors.textOnPrimary,
    ),
    
    // App bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: UAGroColors.primary,
      foregroundColor: UAGroColors.textOnPrimary,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: UAGroColors.textOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: UAGroColors.textOnPrimary,
        size: UAGroConstants.iconMedium,
      ),
    ),
    
    // Card theme
    cardTheme: const CardTheme(
      color: UAGroColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    
    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: UAGroColors.primary,
        foregroundColor: UAGroColors.textOnPrimary,
        elevation: 2,
        padding: EdgeInsets.symmetric(
          horizontal: UAGroConstants.paddingLarge,
          vertical: UAGroConstants.paddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: UAGroColors.primary,
        side: BorderSide(color: UAGroColors.primary, width: 1.5),
        padding: EdgeInsets.symmetric(
          horizontal: UAGroConstants.paddingLarge,
          vertical: UAGroConstants.paddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: UAGroColors.primary,
        padding: EdgeInsets.symmetric(
          horizontal: UAGroConstants.paddingMedium,
          vertical: UAGroConstants.paddingSmall,
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: UAGroColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        borderSide: BorderSide(color: UAGroColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        borderSide: BorderSide(color: UAGroColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        borderSide: BorderSide(color: UAGroColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        borderSide: BorderSide(color: UAGroColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UAGroConstants.radiusMedium),
        borderSide: BorderSide(color: UAGroColors.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: UAGroConstants.paddingMedium,
        vertical: UAGroConstants.paddingMedium,
      ),
      labelStyle: TextStyle(
        color: UAGroColors.textSecondary,
        fontSize: 16,
      ),
      hintStyle: TextStyle(
        color: UAGroColors.textHint,
        fontSize: 16,
      ),
    ),
    
    // Tab bar theme
    tabBarTheme: const TabBarTheme(
      labelColor: UAGroColors.primary,
      unselectedLabelColor: UAGroColors.textSecondary,
      indicatorColor: UAGroColors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Snack bar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: UAGroColors.textPrimary,
      contentTextStyle: TextStyle(
        color: UAGroColors.textOnPrimary,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UAGroConstants.radiusSmall),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // Text theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: UAGroColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: UAGroColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: UAGroColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: UAGroColors.textHint,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Divider theme
    dividerTheme: DividerThemeData(
      color: UAGroColors.divider,
      thickness: 1,
      space: 1,
    ),
    
    // Icon theme
    iconTheme: IconThemeData(
      color: UAGroColors.textPrimary,
      size: UAGroConstants.iconMedium,
    ),
  );
}