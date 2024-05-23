import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/helpers/auth_helpers.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:ghl_callrecoding/repositories/auth_repositories.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:ghl_callrecoding/views/auth/login_page.dart';
import 'package:ghl_callrecoding/views/dashboard/dashboard.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/custom_text_feild.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:toast/toast.dart';

class OnBoardScreen extends StatelessWidget {
  OnBoardScreen({super.key});

  final DashboardController dashboardController =
  Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "GHL India",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth / 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {},
              child: Stack(
                children: [
                  Image(image: AssetImage("assets/image/bg_red_img.png")),
                  Positioned(
                      top: screenWidth / 9,
                      right: screenWidth / 2.9,
                      child: Image(
                        image: AssetImage("assets/image/today_leads_icon.png"),
                      )),
                  Positioned(
                      top: screenWidth / 2.8,
                      right: screenWidth / 12,
                      child: CustomText(
                        text: "Today Leads",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 8,
                      )),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashBoardScreen()));
              },
              child: Stack(
                children: [
                  Image(image: AssetImage("assets/image/bg_blue_img.png")),
                  Positioned(
                      top: screenWidth / 9,
                      right: screenWidth / 2.9,
                      child: Image(
                        image: AssetImage("assets/image/total_leads_icon.png"),
                      )),
                  Positioned(
                      top: screenWidth / 2.8,
                      right: screenWidth / 12,
                      child: CustomText(
                        text: "Total Leads",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 8,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'GHL India Pvt Ltd',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                onTapLogout(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: "Call Recording Path Storing"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                readOnly: true,
                controller: dashboardController.callRecordingFileCon,
                hintText: "Choose File Path",
                onTap: () {
                  dashboardController.pickFile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  onTapLogout(context) async {
    var logoutResponse = await AuthRepository().getLogoutResponse();
    if (logoutResponse.result == true) {
      AuthHelper().clearUserData();
      await SharedPreference().clearUserData();
      ToastComponent.showDialog(logoutResponse.message!.toString(),
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      ToastComponent.showDialog(logoutResponse.message!.toString(),
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }
