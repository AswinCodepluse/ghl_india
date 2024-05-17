import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseRepository {
  final _firebaseInstance = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted Permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional Permission');
    } else {
      print('User denied');
    }
  }

  Future<String> getToken() async {
    String? token = await _firebaseInstance.getToken();
    return token ?? '';
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSprcific =
          AndroidNotificationDetails(
        'GHL', 'GHL',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        // sound: const RawResourceAndroidNotificationSound('notification')
      );
      NotificationDetails platformChannelSpecific =
          NotificationDetails(android: androidPlatformChannelSprcific);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecific,
          payload: message.data['title']);
    });
  }

  // Future<void> scheduleNotification(DateTime scheduledTime) async {
  //   final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     'your channel id',
  //     'your channel name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'Scheduled Notification',
  //       'This is a test notification scheduled at 3:28 PM',
  //       tzScheduledTime,
  //       platformChannelSpecifics,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }
  Duration calculateDelayUntilTargetTime(DateTime targetTime) {
    final now = DateTime.now();
    final targetDateTime = DateTime(
        now.year, now.month, now.day, targetTime.hour, targetTime.minute);

    if (targetDateTime.isBefore(now)) {
      // If the target time is before the current time, schedule it for the next day
      final tomorrow = now.add(Duration(days: 1));
      return Duration(
        days: 1,
        hours: targetTime.hour,
        minutes: targetTime.minute,
      );
    } else {
      // Target time is later today
      return targetDateTime.difference(now);
    }
  }

  void scheduleNotificationAtSpecificTime(DateTime targetTime, String token) {
    Duration delay = calculateDelayUntilTargetTime(targetTime);

    Timer(delay, () {
      sendPushNotification(token, "Reminder");
    });
  }

  void sendPushNotification(String token, String message) async {
    try {
      print('token===============+ $token');
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            'content-Type': 'application/json',
            'Authorization':
                'key=AAAAzzQFlYs:APA91bGpjhllIohYVU7hSKgIwbtAxRrzCe6Ii7gGkgjP-gTg_PhLRjzcaab0mzu8F8MnsmhjcUygzHL3a98RCPVcBRTpt7VQElxz-H5UTLnvPYptfMubHZ2h788I71EDZoNk_Abtu1gr'
          },
          body: jsonEncode({
            'notification': {'title': 'GHL Notification', 'body': message},
            'priority': 'high',
            'to': token
          }));
    } catch (e) {
      print('error $e');
    }
  }
}
