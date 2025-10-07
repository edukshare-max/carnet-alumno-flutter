// Responsive helpers for UAGro app
// Provides utilities for responsive design across mobile and desktop

import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  // Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(8.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  // Responsive container with max width for desktop
  static Widget responsiveContainer({
    required BuildContext context,
    required Widget child,
    double maxWidth = 800,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? getResponsivePadding(context),
      margin: margin ?? getResponsiveMargin(context),
      constraints: isDesktop(context) 
          ? BoxConstraints(maxWidth: maxWidth)
          : null,
      child: isDesktop(context)
          ? Center(child: child)
          : child,
    );
  }

  // Responsive column spacing
  static double getColumnSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 20.0;
    } else {
      return 24.0;
    }
  }

  // Responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    if (isSmallScreen(context)) {
      return 0.9;
    } else if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  // Responsive button padding
  static EdgeInsets getButtonPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0);
    }
  }

  // Responsive icon size
  static double getIconSize(BuildContext context, {double baseSize = 24.0}) {
    return baseSize * getFontSizeMultiplier(context);
  }

  // Responsive grid column count
  static int getGridColumnCount(BuildContext context, {int minItemWidth = 300}) {
    final screenWidth = getScreenWidth(context);
    return (screenWidth / minItemWidth).floor().clamp(1, 4);
  }

  // Check if the screen is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Check if the screen is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    return kToolbarHeight;
  }

  // Get responsive bottom navigation bar height
  static double getBottomNavigationHeight(BuildContext context) {
    return kBottomNavigationBarHeight;
  }

  // Responsive text scaling
  static TextStyle? getResponsiveTextStyle(
    BuildContext context,
    TextStyle? baseStyle,
  ) {
    if (baseStyle == null) return null;
    
    final multiplier = getFontSizeMultiplier(context);
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * multiplier,
    );
  }

  // Responsive card elevation
  static double getCardElevation(BuildContext context) {
    if (isMobile(context)) {
      return 2.0;
    } else {
      return 4.0;
    }
  }
}