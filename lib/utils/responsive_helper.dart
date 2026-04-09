import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Screen size
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  // Initialize responsive values
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  // Responsive width
  static double w(double percentage) {
    return screenWidth * (percentage / 100);
  }

  // Responsive height
  static double h(double percentage) {
    return screenHeight * (percentage / 100);
  }

  // Responsive font size
  static double sp(double percentage) {
    return screenWidth * (percentage / 100);
  }

  // Check screen type
  static bool isMobile(BuildContext context) {
    return screenWidth < 600;
  }

  static bool isTablet(BuildContext context) {
    return screenWidth >= 600 && screenWidth < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return screenWidth >= 1200;
  }

  // Orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Safe area padding
  static double get statusBarHeight =>
      MediaQuery.of(navigatorKey.currentContext!).padding.top;
  static double get bottomBarHeight =>
      MediaQuery.of(navigatorKey.currentContext!).padding.bottom;

  // Keyboard visibility
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  // Get device pixel ratio
  static double get pixelRatio =>
      MediaQuery.of(navigatorKey.currentContext!).devicePixelRatio;

  // Navigation key for context access
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

// Responsive Widget
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (ResponsiveHelper.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (ResponsiveHelper.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

// Responsive Text
class ResponsiveText extends StatelessWidget {
  final String text;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize;

    if (ResponsiveHelper.isDesktop(context)) {
      fontSize = desktopSize ?? mobileSize ?? 16;
    } else if (ResponsiveHelper.isTablet(context)) {
      fontSize = tabletSize ?? mobileSize ?? 14;
    } else {
      fontSize = mobileSize ?? 14;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Responsive SizedBox
class ResponsiveSizedBox extends StatelessWidget {
  final double? mobileHeight;
  final double? mobileWidth;
  final double? tabletHeight;
  final double? tabletWidth;
  final double? desktopHeight;
  final double? desktopWidth;

  const ResponsiveSizedBox({
    super.key,
    this.mobileHeight,
    this.mobileWidth,
    this.tabletHeight,
    this.tabletWidth,
    this.desktopHeight,
    this.desktopWidth,
  });

  @override
  Widget build(BuildContext context) {
    double height;
    double width;

    if (ResponsiveHelper.isDesktop(context)) {
      height = desktopHeight ?? mobileHeight ?? 0;
      width = desktopWidth ?? mobileWidth ?? 0;
    } else if (ResponsiveHelper.isTablet(context)) {
      height = tabletHeight ?? mobileHeight ?? 0;
      width = tabletWidth ?? mobileWidth ?? 0;
    } else {
      height = mobileHeight ?? 0;
      width = mobileWidth ?? 0;
    }

    return SizedBox(height: height, width: width);
  }
}

// Responsive Padding
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? mobileAll;
  final double? tabletAll;
  final double? desktopAll;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobileAll,
    this.tabletAll,
    this.desktopAll,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;

    if (ResponsiveHelper.isDesktop(context)) {
      padding = desktopPadding ?? EdgeInsets.all(desktopAll ?? 24);
    } else if (ResponsiveHelper.isTablet(context)) {
      padding = tabletPadding ?? EdgeInsets.all(tabletAll ?? 16);
    } else {
      padding = mobilePadding ?? EdgeInsets.all(mobileAll ?? 12);
    }

    return Padding(padding: padding, child: child);
  }
}
