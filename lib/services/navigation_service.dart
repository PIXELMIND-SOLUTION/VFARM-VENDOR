import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      ResponsiveHelper.navigatorKey;

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToReplacement(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToAndRemoveUntil(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop(result);
  }

  static bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }
}
