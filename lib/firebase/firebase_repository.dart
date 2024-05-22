import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:http/http.dart' as http;

class FirebaseRepository {
  final _firebaseInstance = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseInstance.requestPermission(
      alert: true,
      announcement: true,
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
    print('token  $token');
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
      AndroidNotificationDetails androidPlatformChannelSpecific =
          AndroidNotificationDetails(
        'GHL', 'GHL',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        // sound: const RawResourceAndroidNotificationSound('notification')
      );
      NotificationDetails platformChannelSpecific =
          NotificationDetails(android: androidPlatformChannelSpecific);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecific,
          payload: message.data['title']);
    });
  }

  Duration calculateDelayUntilTargetTime(DateTime targetTime) {
    final now = DateTime.now();
    final targetDateTime = DateTime(
        now.year, now.month, now.day, targetTime.hour, targetTime.minute);

    if (targetDateTime.isBefore(now)) {
      return Duration(
        days: 1,
        hours: targetTime.hour,
        minutes: targetTime.minute,
      );
    } else {
      return targetDateTime.difference(now);
    }
  }

  void scheduleNotificationAtSpecificTime(DateTime targetTime, String token) {
    Duration delay = calculateDelayUntilTargetTime(targetTime);

    Timer(delay, () {
      sendPushNotification(token, "Reminder", targetTime);
    });
  }

  Future<void> setNotification() async {
    SharedPreference sharedPreference = SharedPreference();
    String dateString = await sharedPreference.getRemainderDate();
    String getRemainderTime = await sharedPreference.getRemainderTime();
    String TimeString = getRemainderTime == "" ? "10:00" : getRemainderTime;
    List<String> dateParts = dateString.split('-');
    List<String> timeParts = TimeString.split(':');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    FirebaseRepository firebaseRepo = FirebaseRepository();
    var deviceToken = await sharedPreference.getDeviceToken();
    final targetDateTime = DateTime(year, month, day, hour, minute);
    firebaseRepo.scheduleNotificationAtSpecificTime(
        targetDateTime, deviceToken);
  }

  void sendPushNotification(
      String token, String message, DateTime targetDateTime) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            'content-Type': 'application/json',
            'Authorization':
                'key=AAAAzzQFlYs:APA91bGpjhllIohYVU7hSKgIwbtAxRrzCe6Ii7gGkgjP-gTg_PhLRjzcaab0mzu8F8MnsmhjcUygzHL3a98RCPVcBRTpt7VQElxz-H5UTLnvPYptfMubHZ2h788I71EDZoNk_Abtu1gr'
          },
          body: jsonEncode({
            'priority': 'high',
            // 'targetDateTime': targetDateTime.toIso8601String(),
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': message,
              'title': 'GHL Notification',
            },
            'notification': {
              'title': 'GHL Notification',
              'body': message,
              'android_channel_id': "GHL"
            },
            'to': token
          }));
    } catch (e) {
      print('error $e');
    }
  }
}
