import 'package:flutter/material.dart';
import 'package:todo_list/routes.dart';
import 'package:todo_list/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppPages.generateRoute,
    );
  }
}
