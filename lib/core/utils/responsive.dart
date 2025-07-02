import 'package:flutter/material.dart';

/// Responsive utility class for adaptive UI design across all screen sizes.
/// 
/// Handles everything from iPhone SE (375px) to iPad Pro (1366px) and beyond.
/// Provides breakpoints, adaptive sizing, and device-specific optimizations.
class Responsive {
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;
  static const double _desktopBreakpoint = 1200;
  
  // Screen size categories
  static const double _smallMobileWidth = 375; // iPhone SE, small Android
  static const double _mediumMobileWidth = 390; // iPhone 12/13/14
  static const double _largeMobileWidth = 430; // iPhone Pro Max
  static const double _smallTabletWidth = 768; // iPad Mini
  static const double _largeTabletWidth = 1024; // iPad Pro

  /// Gets the current screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Gets the current screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Determines if device is mobile (< 600px)
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < _mobileBreakpoint;
  }

  /// Determines if device is tablet (600px - 900px)
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= _mobileBreakpoint && width < _tabletBreakpoint;
  }

  /// Determines if device is desktop (> 900px)
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= _tabletBreakpoint;
  }

  /// Determines if device is small mobile (< 375px)
  static bool isSmallMobile(BuildContext context) {
    return screenWidth(context) <= _smallMobileWidth;
  }

  /// Determines if device is large mobile (> 400px)
  static bool isLargeMobile(BuildContext context) {
    final width = screenWidth(context);
    return width > 400 && width < _mobileBreakpoint;
  }

  /// Returns adaptive value based on screen size
  /// 
  /// Example: Responsive.value(context, mobile: 16, tablet: 24, desktop: 32)
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  /// Returns adaptive padding based on screen size
  static EdgeInsets padding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final size = value(
      context,
      mobile: mobile ?? 16,
      tablet: tablet ?? 24,
      desktop: desktop ?? 32,
    );
    return EdgeInsets.all(size);
  }

  /// Returns adaptive horizontal padding
  static EdgeInsets horizontalPadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final size = value(
      context,
      mobile: mobile ?? 24,
      tablet: tablet ?? 32,
      desktop: desktop ?? 48,
    );
    return EdgeInsets.symmetric(horizontal: size);
  }

  /// Returns adaptive font size
  static double fontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? mobile * 1.4,
    );
  }

  /// Returns adaptive width based on percentage of screen
  static double widthPercent(BuildContext context, double percent) {
    return screenWidth(context) * (percent / 100);
  }

  /// Returns adaptive height based on percentage of screen
  static double heightPercent(BuildContext context, double percent) {
    return screenHeight(context) * (percent / 100);
  }

  /// Returns adaptive spacing between elements
  static double spacing(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: mobile ?? 8,
      tablet: tablet ?? 12,
      desktop: desktop ?? 16,
    );
  }

  /// Returns adaptive card border radius
  static double borderRadius(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: mobile ?? 16,
      tablet: tablet ?? 20,
      desktop: desktop ?? 24,
    );
  }

  /// Returns adaptive icon size
  static double iconSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? mobile * 1.4,
    );
  }

  /// Returns adaptive button height
  static double buttonHeight(BuildContext context) {
    return value(
      context,
      mobile: 48,
      tablet: 56,
      desktop: 64,
    );
  }

  /// Returns adaptive app bar height
  static double appBarHeight(BuildContext context) {
    return value(
      context,
      mobile: 56,
      tablet: 64,
      desktop: 72,
    );
  }

  /// Returns adaptive grid columns for responsive grids
  static int gridColumns(BuildContext context) {
    return value(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }

  /// Returns adaptive tab width for responsive tab bars
  static double tabWidth(BuildContext context) {
    final screenW = screenWidth(context);
    if (screenW <= 350) return 60; // Very small devices (iPhone SE in landscape, old Android)
    if (isSmallMobile(context)) return 68;
    if (screenW < 400) return 75;
    if (isLargeMobile(context)) return 85;
    if (isTablet(context)) return 100;
    return 120; // Desktop
  }

  /// Returns adaptive stamp size for swipe interactions
  static double stampSize(BuildContext context) {
    return value(
      context,
      mobile: isSmallMobile(context) ? 100 : 120,
      tablet: 140,
      desktop: 160,
    );
  }

  /// Returns adaptive job card height
  static double jobCardHeight(BuildContext context) {
    return screenHeight(context) * value(
      context,
      mobile: 0.75,
      tablet: 0.7,
      desktop: 0.65,
    );
  }

  /// Returns adaptive profile avatar size
  static double avatarSize(BuildContext context) {
    return value(
      context,
      mobile: isSmallMobile(context) ? 80 : 100,
      tablet: 120,
      desktop: 140,
    );
  }

  /// Returns adaptive max content width for large screens
  static double maxContentWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
    );
  }

  /// Returns whether to use horizontal layout (for tablets in landscape)
  static bool useHorizontalLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height && size.width > 600;
  }
} 