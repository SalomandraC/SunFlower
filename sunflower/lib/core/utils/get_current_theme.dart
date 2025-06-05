import 'package:flutter/material.dart';
import 'package:sunflower/theme/theme.dart';

ThemeData getCurrentTheme(bool isDarkTheme) {
  return isDarkTheme ? AppTheme.darkTheme : AppTheme.ligthTheme;
}
