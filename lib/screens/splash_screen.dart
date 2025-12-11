import 'package:flutter/material.dart';
import 'package:todo_list/core/assets.dart';
import 'package:todo_list/core/colors.dart';
import 'package:todo_list/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Image.asset(AppAssets.SplashLogo),
      ),
    );
  }
}
