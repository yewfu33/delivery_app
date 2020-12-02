import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();

  get navigatorKey => _navigatorKey;

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndRemoveUntil(String routeName,
      {dynamic arguments}) {
    return _navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  void navigatePop() {
    return _navigatorKey.currentState.pop();
  }
}
