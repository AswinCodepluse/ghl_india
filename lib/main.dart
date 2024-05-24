import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/binding/controller_binding.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/views/splash_screen.dart';
import 'package:one_context/one_context.dart';

import 'package:shared_value/shared_value.dart';

import 'firebase/firebase_repository.dart';
import 'firebase_options.dart';

// @pragma("vm:entry-point")
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('message id ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseMessaging.instance.getInitialMessage();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  FirebaseRepository firebaseRepo = FirebaseRepository();
  firebaseRepo.requestPermission();
  var token = await firebaseRepo.getToken();
  print('device token $token');
  SharedPreference().setDeviceToken(token);
  // firebaseRepo.initInfo();
  // firebaseRepo.setNotification();

  runApp(
    SharedValue.wrapApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: OneContext().builder,
      navigatorKey: OneContext().navigator.key,
      title: 'GHL Leads',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialBinding: ControllerBinding(),
      home: const SplashScreen(),
    );
  }
}
