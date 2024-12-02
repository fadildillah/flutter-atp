import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atp/controllers/user_controller.dart';
import 'package:flutter_atp/resources/theme.dart';
import 'package:flutter_atp/services/api/supabase_service.dart';
import 'package:flutter_atp/views/navigations/app_routes.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  await Alarm.init();

  // Initialize UserController before running the app
  Get.put(UserController());

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ThemeMode _themeMode;
  final UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    // Initialize theme mode from controller
    _themeMode = _userController.themeMode;

    // Listen to theme changes
    ever(_userController.themeModeObservable, (int mode) {
      setState(() {
        _themeMode = _userController.themeMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter ATP',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.pages,
    );
  }
}
