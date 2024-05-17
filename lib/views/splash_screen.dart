import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/views/auth/login_page.dart';
import 'package:package_info/package_info.dart';
import '../app_config.dart';
import '../helpers/auth_helpers.dart';
import '../utils/shared_value.dart';
import 'dashboard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: AppConfig.app_name,
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    getSharedValueHelperData().then((value) {
      print("access Value====>${value}");
      Future.delayed(const Duration(seconds: 3)).then((value) async {
        final isLogged = await SharedPreference().getLogin();
        if (isLogged) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashBoard()));
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
            (route) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image(
            image: AssetImage('assets/image/app_logo.png'),
          ),
        ),
      ),
    );
  }

  Future<String?> getSharedValueHelperData() async {
    access_token.load().whenComplete(() {
      AuthHelper().fetch_and_set();
    });
    // AddonsHelper().setAddonsData();
    // BusinessSettingHelper().setBusinessSettingData();
    await app_language.load();
    await app_mobile_language.load();
    await app_language_rtl.load();
    await system_currency.load();
    // Provider.of<CurrencyPresenter>(context, listen: false).fetchListData();
    // print("new splash screen ${app_mobile_language.$}");
    // print("new splash screen app_language_rtl ${app_language_rtl.$}");
    return app_mobile_language.$;
  }
}