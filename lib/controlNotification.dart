import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'UI/homepage.dart';

///push notifications at a specific time and cancel them.
class ControlNotification {
  static ControlNotification controlNotification;

  static const _androidChannelId = '#TodoChannelId0';
  static const _androidChannelName = 'reminder Notification';
  static const _androidChannelDescription =
      'remind the user if they add a reminder to a specific note';

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final androidInitializationSettings =
  AndroidInitializationSettings('reminder');

  IOSInitializationSettings iosInitializationSettings;

  InitializationSettings initializationSettings;

  BuildContext context;

  ///Singleton
  factory ControlNotification(BuildContext context) {
    controlNotification ??= ControlNotification._(context);

    return controlNotification;
  }

  ControlNotification._(this.context) {
    iosInitializationSettings = IOSInitializationSettings(
      //For Ios 10 or below.
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          selectNotification(payload),
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  ///When The user press the notification.
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  ///Push notification now.
  ///
  ///For testing only :)
  Future<void> pushNotification({
    int id = 0,
    String title = '',
    String description = '',
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      _androidChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'title:$title , desciption:$description',
    );

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      description,
      platformChannelSpecifics,
      payload: 'Some Data to Send if you want',
    );
  }

  Future<void> pushScheduledNotification({
    int id = 0,
    String title = '',
    String body = '',
    @required DateTime dateTime,
  }) async {
    if (dateTime == null) return;

    // final scheduledNotificationDateTime = DateTime.now().add(Duration(
    //     days: dateTime.day, hours: dateTime.hour, minutes: dateTime.minute));

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      _androidChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'title:$title , desciption:$body',
    );

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      id,
      'you have new reminder',
      title,
      dateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
