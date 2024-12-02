import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  // Create an observable for theme mode
  final RxInt _themeModeIndex = 0.obs;

  // Expose an observable for theme mode changes
  RxInt get themeModeObservable => _themeModeIndex;

  // Compute ThemeMode from the index
  ThemeMode get themeMode {
    switch (_themeModeIndex.value) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    _themeModeIndex.value = prefs.getInt('theme_mode_index') ?? 0;
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    int modeIndex;
    switch (mode) {
      case ThemeMode.system:
        modeIndex = 0;
        break;
      case ThemeMode.light:
        modeIndex = 1;
        break;
      case ThemeMode.dark:
        modeIndex = 2;
        break;
    }

    await prefs.setInt('theme_mode_index', modeIndex);
    _themeModeIndex.value = modeIndex;
  }
}
