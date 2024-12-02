import 'package:flutter/material.dart';
import 'package:flutter_atp/controllers/user_controller.dart';
import 'package:flutter_atp/core/widgets/custom_switch.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              // Use Obx to make the switch reactive
              return ListTile(
                title: const Text('Theme Mode'),
                trailing: CustomDarkModeSwitch(
                  initialMode: _userController.themeMode == ThemeMode.dark,
                  onThemeChanged: (isDark) {
                    _userController.changeThemeMode(
                        isDark ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
