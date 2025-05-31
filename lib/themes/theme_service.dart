import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService {
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;

  ThemeMode get theme => _themeMode.value;

  void toggleTheme() {
    _themeMode.value =
        _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  Rx<ThemeMode> get themeMode => _themeMode;
}
