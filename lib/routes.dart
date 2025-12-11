import 'package:flutter/material.dart';
import 'package:todo_list/screens/splash_screen.dart';
import 'package:todo_list/screens/todo_screen.dart';


class AppRoutes{
  static const String splash = '/';
  static const String todo = '/todo';
}


class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case AppRoutes.todo:
        return MaterialPageRoute(builder: (_) => TodoScreen());


      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No Route Found: ${settings.name}"),
            ),
          ),
        );
    }
  }
}