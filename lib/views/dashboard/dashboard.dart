import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/views/leadsDetails/lead_screen.dart';
import 'package:ghl_callrecoding/views/recording_files/file_screen.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import '../../helpers/auth_helpers.dart';
import '../../utils/shared_value.dart';
import '../auth/login_page.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => FileScreen());
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.file_copy),
              )),
          GestureDetector(
              onTap: () {
                Get.to(() => LeadScreen());
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.person),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // searchBar(dashboardController.searchCon, dashboardController),
              // SizedBox(
              //   height: 15,
              // ),
              Row(
                children: [
                  Expanded(
                      child: dashboardContainer(
                          color: Color(0xFF7569DE),
                          text: "Total Leads",
                          icon: "assets/image/dashboard_icon_1.png",
                          count: 89)),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: dashboardContainer(
                          color: Color(0xFFB1DE52),
                          text: "Website Lead",
                          icon: "assets/image/dashboard_icon_2.png",
                          count: 0)),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                      child: dashboardContainer(
                          color: Color(0xFFD9EADA),
                          text: "Facebook Lead",
                          icon: "assets/image/dashboard_icon_3.png",
                          count: 69)),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: dashboardContainer(
                          color: Color(0xFFF3C41F),
                          text: "Google Lead",
                          icon: "assets/image/google_drive_icon.png",
                          count: 05)),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: dashboardController.dashboardCountList.length,
                  itemBuilder: (context, index) {
                    final data = dashboardController.dashboardCountList[index];
                    final randomColor = dashboardController.colors[
                        Random().nextInt(dashboardController.colors.length)];
                    return roundContainer(
                        count: data.count!,
                        text: data.name!,
                        color: randomColor);
                  },
                );
              }),
              SizedBox(
                height: 15,
              ),
            ],
          ),
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
          ],
        ),
      ),
    );
  }

  Widget roundContainer(
      {required int count, String? color, required String text}) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          child: Center(
            child: CustomText(
              text: count.toString(),
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
              color: dashboardController.getColor(color!),
              shape: BoxShape.circle),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
            width: 68,
            child: Center(
                child: CustomText(
              text: text,
              fontSize: 13,
            )))
      ],
    );
  }

  Widget dashboardContainer(
      {required Color color,
      required String text,
      required int count,
      required String icon}) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            child: Image(
              image: AssetImage(icon),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FittedBox(
            child: CustomText(
              text: text,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          Spacer(),
          Center(
              child: CustomText(
            text: count.toString(),
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ))
        ],
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  onTapLogout(context) async {
    AuthHelper().clearUserData();
    await SharedPreference().setLogin(false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
