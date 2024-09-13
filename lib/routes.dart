import 'package:flutter/material.dart';
import 'pages/register_page.dart';
import 'pages/view_cats_page.dart';
import 'pages/welcome_page.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String register = '/register';
  static const String viewCats = '/view-cats';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => WelcomePage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case viewCats:
        return MaterialPageRoute(builder: (_) => ViewCatsPage());
      default:
        return MaterialPageRoute(builder: (_) => WelcomePage());
    }
  }
}
