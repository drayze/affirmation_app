import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
//import 'package:timezone/data/latest.dart' as tz;

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
  //static const String channelDescription =
  //'Channel for daily affirmation reminders';

  static final Notifications _notifications = Notifications._internal();
  factory Notifications() {
    return _notifications;
  }
  Notifications._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    //tz.initializeTimeZones();
    //final String currentTimeZone = DateTime.now().timeZoneName;
    //tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    //final IOSInitializationSettings iosInitializationSettingsIOS =
    //  IOSInitializationSettings(
    // requestAlertPermission: false,
    // requestBadgePermission: false,
    // requestSoundPermission: false,
    //);
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          //iOS: initializationSettingsIOS,
        );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
    debugPrint("Notifications initialized");
  }

  NotificationDetails constNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      //iOS: IOSNotificationDetails(),
    );
  }

  Future<void> scheduleNotification(DateTime notificationTime) async {
    if (notificationTime.isBefore(DateTime.now())) {
      notificationTime = notificationTime.add(const Duration(days: 1));
    }
    final tz.TZDateTime scheduledNotificationTime = tz.TZDateTime.from(
      notificationTime,
      tz.local,
    );
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Daily Reminder",
        "Don't forget to be kind 2 u",
        scheduledNotificationTime,
        constNotificationDetails(), // Get the details from our helper method
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
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
}
