import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/home_screen.dart';
import '../screens/friends_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/create_top3_screen.dart';
import '../screens/all_top3_screen.dart';

class AppRouter {
  // Route names
  static const String main = '/';
  static const String home = '/home';
  static const String friends = '/friends';
  static const String statistics = '/statistics';
  static const String profile = '/profile';
  static const String createTop3 = '/create-top3';
  static const String allTop3 = '/all-top3';
    // Route generation
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case friends:
        return MaterialPageRoute(builder: (_) => const FriendsScreen());
      case statistics:
        return MaterialPageRoute(builder: (_) => const StatisticsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());      case createTop3:
        return MaterialPageRoute(builder: (_) => const CreateTop3Screen());
      case allTop3:
        return MaterialPageRoute(builder: (_) => const AllTop3Screen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}