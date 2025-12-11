import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      
      return status ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    
    return true;
  }

  Future<void> scheduleTaskReminder({
    required String taskId,
    required String title,
    required DateTime reminderTime,
    required TaskPriority priority,
  }) async {
    if (!await requestPermissions()) {
      debugPrint('Notification permissions not granted');
      return;
    }

    await initialize();

    String priorityText = '';
    Color priorityColor = Colors.blue;
    
    switch (priority) {
      case TaskPriority.high:
        priorityText = 'High Priority';
        priorityColor = Colors.red;
        break;
      case TaskPriority.medium:
        priorityText = 'Medium Priority';
        priorityColor = Colors.orange;
        break;
      case TaskPriority.low:
        priorityText = 'Low Priority';
        priorityColor = Colors.green;
        break;
    }

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Reminders for your tasks',
      importance: priority == TaskPriority.high 
          ? Importance.high 
          : Importance.defaultImportance,
      priority: priority == TaskPriority.high 
          ? Priority.high 
          : Priority.defaultPriority,
      color: priorityColor,
      icon: '@mipmap/ic_launcher',
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: priority == TaskPriority.high 
          ? InterruptionLevel.timeSensitive 
          : InterruptionLevel.active,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(taskId),
        'Task Reminder: $title',
        'Priority: $priorityText',
        tz.TZDateTime.from(reminderTime, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      
      debugPrint('Scheduled reminder for task: $title at $reminderTime');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    await _flutterLocalNotificationsPlugin.cancel(int.parse(taskId));
    debugPrint('Cancelled reminder for task: $taskId');
  }

  Future<void> cancelAllReminders() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('Cancelled all reminders');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    debugPrint('Notification tapped: ${notificationResponse.payload}');
  }
}
