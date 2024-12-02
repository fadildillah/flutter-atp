import 'package:flutter_atp/views/screens/destination/destination_page.dart';
import 'package:flutter_atp/views/screens/home_page.dart';
import 'package:flutter_atp/views/screens/notification_page.dart';
import 'package:flutter_atp/views/screens/setting_page.dart';
import 'package:flutter_atp/views/screens/trips/trip_page.dart';
import 'bottom_tab.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String get initial => '/';

  // bottom tab

  static final List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const BottomTab(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/home',
      page: () => HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/notification',
      page: () => const NotificationPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/setting',
      page: () => SettingPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/trip',
      page: () => TripPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/destination',
      page: () => DestinationPage(),
      transition: Transition.fadeIn,
    )
  ];
}
