import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

// This function needs to be a top-level function (not inside a class)
// It handles what happens when a user taps on the notification.
Future<void> onSelectNotification(
  NotificationResponse notificationResponse,
) async {
  // For now, we'll just print to the console.
  // Later, you could navigate to a specific screen.
  debugPrint('Notification Tapped: ${notificationResponse.payload}');
}

class Notifications {
  static const String channelId = 'daily_affirmation_channel';
  static const String channelName = 'Daily Affirmations';
  static const String channelDescription =
      'Daily affirmations and check-in reminders';

  static final Notifications _notifications = Notifications._internal();
  factory Notifications() {
    return _notifications;
  }
  Notifications._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late tz.Location _local;

  Future<void> init(tz.Location location) async {
    _local = location;
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
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
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
    debugPrint("Notifications initialized");
  }

  Future<bool> _requestAllPermission() async {
    // Request permission for notifications
    PermissionStatus notificationStatus = await Permission.notification.status;
    if (notificationStatus.isDenied) {
      notificationStatus = await Permission.notification.request();
    }
    // Request permission for exact alarm
    PermissionStatus exactAlarmStatus =
        await Permission.scheduleExactAlarm.status;
    if (exactAlarmStatus.isDenied) {
      exactAlarmStatus = await Permission.scheduleExactAlarm.request();
    }
    debugPrint("Notification permission status: $notificationStatus");
    debugPrint("Exact alarm permission status: $exactAlarmStatus");
    return notificationStatus.isGranted && exactAlarmStatus.isGranted;
  }

  Future<void> scheduleNotification(DateTime notificationTime) async {
    final bool hasPermission = await _requestAllPermission();
    if (!hasPermission) {
      debugPrint(
        "One or more permissions were denied. Cannot schedule notification.",
      );
      return;
    }
    final tz.TZDateTime scheduledNotificationTime = _nextInstanceOfNotification(
      notificationTime,
    );
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Daily Reminder",
        "Don't forget to be kind 2 u",
        scheduledNotificationTime,
        _constNotificationDetails(), // Get the details from our helper method
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        //uiLocalNotificationDateInterpretation:
        //  UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.time, // Repeat daily at this time
      );
      debugPrint(
        "Notification scheduled successfully for $scheduledNotificationTime",
      );
    } catch (e) {
      debugPrint("Error scheduling notification: $e");
    }
  }

  tz.TZDateTime _nextInstanceOfNotification(DateTime time) {
    final tz.TZDateTime now = tz.TZDateTime.now(_local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      _local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  NotificationDetails _constNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}

class UILocalNotificationDateInterpretation {}
