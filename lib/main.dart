import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/binding/controller_binding.dart';
import 'package:ghl_callrecoding/views/dashboard/dashboard.dart';
import 'package:ghl_callrecoding/views/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GHL Call Recording',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: ControllerBinding(),
      home: const SplashScreen(),
    );
  }
}

