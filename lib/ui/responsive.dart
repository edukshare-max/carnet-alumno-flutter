import 'package:flutter/material.dart';

/// Responsive breakpoints and utility functions for the UAGro Carnet App
class Responsive {
  Responsive._();

  // Breakpoint constants
  static const double kMobileMax = 600.0;
  static const double kTabletMax = 1024.0;

  /// Check if the current screen size is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < kMobileMax;
  }

  /// Check if the current screen size is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= kMobileMax && width < kTabletMax;
  }

  /// Check if the current screen size is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= kTabletMax;
  }

  /// Get the appropriate padding based on screen size
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(12.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  /// Get compact padding for mobile devices
  static EdgeInsets getCompactPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(8.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }

  /// Get the maximum width constraint for content on larger screens
  static double getMaxWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 800.0;
    }
    return double.infinity;
  }

  /// Wrap content with responsive constraints
  static Widget constrainWidth({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
  }) {
    if (isDesktop(context)) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? getMaxWidth(context),
          ),
          child: child,
        ),
      );
    }
    return child;
  }

  /// Get responsive column count for grids
  static int getColumnCount(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  /// Get responsive font size scaling
  static double getFontScale(BuildContext context) {
    if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /// Get responsive button width
  static double? getButtonWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity; // Full width on mobile
    } else {
      return null; // Auto width on larger screens
    }
  }

  /// Create a responsive scaffold with proper constraints
  static Widget responsiveScaffold({
    required BuildContext context,
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? drawer,
    Widget? endDrawer,
    Color? backgroundColor,
  }) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: constrainWidth(
        context: context,
        child: body,
      ),
    );
  }
}

/// A responsive container that adapts its layout based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final bool center;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.maxWidth,
    this.center = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding ?? Responsive.getPadding(context),
      child: child,
    );

    if (Responsive.isDesktop(context)) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? Responsive.getMaxWidth(context),
          ),
          child: content,
        ),
      );
    } else if (center && !Responsive.isMobile(context)) {
      content = Center(child: content);
    }

    return content;
  }
}

/// A responsive layout that can display children in different arrangements
/// based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (Responsive.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

/// A responsive row that can switch to column on smaller screens
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const ResponsiveRow({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children
            .expand((child) => [child, SizedBox(height: spacing)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .expand((child) => [child, SizedBox(width: spacing)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    }
  }
}