import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/call_log_fun/call_log.dart';
import 'package:ghl_callrecoding/local_db/hive_db/call_recording_file_hive_model.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/views/splash_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:one_context/one_context.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_value/shared_value.dart';
import 'firebase/firebase_repository.dart';
import 'firebase_options.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('message id ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(CallRecordingHiveModelAdapter());
  await Hive.openBox<CallRecordingHiveModel>('call_recordings');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
  firebaseRepo.initInfo();
  initializeService();
  runApp(
    SharedValue.wrapApp(
      const MyApp(),
    ),
  );
}

void initializeService() {
  FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      autoStart: true,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  bool adapterRegistered = false;
  try {
    Hive.registerAdapter(CallRecordingHiveModelAdapter());
    adapterRegistered = true;
  } catch (e) {
    if (e is HiveError &&
        e.message.contains('There is already a TypeAdapter for typeId')) {
      adapterRegistered = true;
    } else {
      rethrow;
    }
  }
  if (adapterRegistered) {
    await Hive.openBox<CallRecordingHiveModel>('call_recordings');
  }

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Background Service",
          content: "App Run In Background",
        );
      }
    }

    if (await SharedPreference().getToken() != null) {
      CallLogFun().fetchAllCallLogs();
    }
  });
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
      home: const SplashScreen(),
    );
  }
}
