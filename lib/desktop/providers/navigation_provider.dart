import 'package:flutter/material.dart';

enum DesktopScreen {
  dashboard,
  platforms,
  history,
  settings,
  about,
}

class NavigationProvider extends ChangeNotifier {
  DesktopScreen _currentScreen = DesktopScreen.dashboard;

  DesktopScreen get currentScreen => _currentScreen;

  void navigateTo(DesktopScreen screen) {
    if (_currentScreen != screen) {
      _currentScreen = screen;
      notifyListeners();
    }
  }
}
