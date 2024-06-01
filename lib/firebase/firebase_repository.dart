import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/views/leadsDetails/leads_details.dart';
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
      print('message++++++++++=  ${message.data}');
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
          payload: message.data['data']);
      initLocalNotifications(message);
    });
  }

  void initLocalNotifications(RemoteMessage message) async {
    print('message=========  ${message.data}');
    Map<String, dynamic> notificationData= message.data;
    print('notificationData  $notificationData');
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
       handleMessage(message.data);
    });
  }

  Future<void> setupInteractMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('===========initialMessage=================');
      print(initialMessage.data);

      handleMessage(initialMessage.data);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      handleMessage(event.data);
    });
  }

  void handleMessage(Map<String, dynamic> message) {
    Get.to(
      () => LeadDetailsScreen(
        phoneNumber: message['phoneNumber'],
        firstLetter: message['firstLetter'],
        lastLetter: message['secondLetter'],
        leadName: message['leadName'],
        leadId: int.parse(message['leadId']),
        email: message['email'],
        userName: message['userName'],
      ),
    );
  }

  // Duration calculateDelayUntilTargetTime(DateTime targetTime) {
  //   final now = DateTime.now();
  //   final targetDateTime = DateTime(
  //       now.year, now.month, now.day, targetTime.hour, targetTime.minute);
  //
  //   if (targetDateTime.isBefore(now)) {
  //     return Duration(
  //       days: 1,
  //       hours: targetTime.hour,
  //       minutes: targetTime.minute,
  //     );
  //   } else {
  //     return targetDateTime.difference(now);
  //   }
  // }

  // void scheduleNotificationAtSpecificTime(DateTime targetTime, String token) {
  //   Duration delay = calculateDelayUntilTargetTime(targetTime);
  //
  //   Timer(delay, () {
  //     sendPushNotification(
  //       token, "Reminder",
  //       // targetTime
  //     );
  //   });
  // }

  // Future<void> setNotification() async {
  //   SharedPreference sharedPreference = SharedPreference();
  //   String dateString = await sharedPreference.getRemainderDate();
  //   String getRemainderTime = await sharedPreference.getRemainderTime();
  //   if (dateString != "") {
  //     String TimeString = getRemainderTime == "" ? "10:00" : getRemainderTime;
  //     List<String> dateParts = dateString.split('-');
  //     List<String> timeParts = TimeString.split(':');
  //     int year = int.parse(dateParts[0]);
  //     int month = int.parse(dateParts[1]);
  //     int day = int.parse(dateParts[2]);
  //     int hour = int.parse(timeParts[0]);
  //     int minute = int.parse(timeParts[1]);
  //     FirebaseRepository firebaseRepo = FirebaseRepository();
  //     var deviceToken = await sharedPreference.getDeviceToken();
  //     final targetDateTime = DateTime(year, month, day, hour, minute);
  //     firebaseRepo.scheduleNotificationAtSpecificTime(
  //         targetDateTime, deviceToken);
  //   }
  // }

  void sendPushNotification(
    String token,
    String message,
    // DateTime targetDateTime
  ) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            'content-Type': 'application/json',
            'Authorization':
                'key=AAAAzzQFlYs:APA91bGpjhllIohYVU7hSKgIwbtAxRrzCe6Ii7gGkgjP-gTg_PhLRjzcaab0mzu8F8MnsmhjcUygzHL3a98RCPVcBRTpt7VQElxz-H5UTLnvPYptfMubHZ2h788I71EDZoNk_Abtu1gr'
          },
          body: jsonEncode({
            'priority': 'high',
            'data': {
              "firstLetter": "A",
              "secondLetter": "J",
              "leadId": 1,
              "phoneNumber": "9025075398",
              "email": "notification@gmail.com",
              "userName": "Jana",
              "leadName": "Jana"
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
