import 'package:flutter/material.dart';
import 'package:sunflower/create_figure/presentation/screens/math_part_screen.dart';
import 'package:sunflower/home/presentation/screens/home_screen.dart';
import 'package:sunflower/settings/presentation/screens/settings_screeen.dart';

class NavbarModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<Widget> _screens = [
    HomePage(),
    SunflowerPage(),
    SettingsScreen(),
  ];

  void changeItem(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Widget getCurrentPage() {
    return _screens[_currentIndex];
  }
}
