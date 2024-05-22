import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/helpers/auth_helpers.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/views/auth/login_page.dart';
import 'package:ghl_callrecoding/views/lead_status_details/filter_details.dart';
import 'package:ghl_callrecoding/views/leadsDetails/lead_screen.dart';
import 'package:ghl_callrecoding/views/recording_files/file_screen.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final DashboardController dashboardController = Get.find();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
        ],
      ),
      body: RefreshIndicator(
        color: Colors.red,
        backgroundColor: Colors.white,
        displacement: 0,
        key: refreshIndicatorKey,
        onRefresh: dashboardController.refreshData,
        child: Obx(() {
          return dashboardController.isLeads.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Obx(() {
                              return InkWell(
                                child: dashboardContainer(
                                    color: Colors.green,
                                    text: "Total Leads",
                                    icon: "assets/image/dashboard_icon_1.png",
                                    count: dashboardController.totalLead.value),
                                onTap: () {
                                  Get.to(() => LeadScreen(
                                        platforms: "allLeads",
                                      ));
                                },
                              );
                            })),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(child: Obx(() {
                              return InkWell(
                                child: dashboardContainer(
                                    color: Colors.red,
                                    text: "Website Lead",
                                    icon: "assets/image/dashboard_icon_2.png",
                                    count:
                                        dashboardController.websiteLead.value),
                                onTap: () {
                                  Get.to(() => LeadScreen(
                                        platforms: "website",
                                      ));
                                },
                              );
                            })),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(child: Obx(() {
                              return InkWell(
                                child: dashboardContainer(
                                    color: Color(0xFF7569DE),
                                    text: "Facebook Lead",
                                    icon: "assets/image/dashboard_icon_3.png",
                                    count:
                                        dashboardController.facebookLead.value),
                                onTap: () {
                                  Get.to(() => LeadScreen(
                                        platforms: "facebook",
                                      ));
                                },
                              );
                            })),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(child: Obx(() {
                              return InkWell(
                                child: dashboardContainer(
                                    color: Color(0xFFF3C41F),
                                    text: "Google Lead",
                                    icon: "assets/image/google_drive_icon.png",
                                    count:
                                        dashboardController.googleLead.value),
                                onTap: () {
                                  Get.to(() => LeadScreen(
                                        platforms: "google",
                                      ));
                                },
                              );
                            })),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Obx(() {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount:
                                dashboardController.dashboardCountList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  dashboardController.dashboardCountList[index];
                              final randomColor = dashboardController.colors[
                                  Random().nextInt(
                                      dashboardController.colors.length)];
                              return roundContainer(
                                  count: data.count!,
                                  text: data.name!,
                                  index: index,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeadDatasFilterStatus()));
                                  },
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
                );
        }),
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
      {required int count,
      int? index,
      String? color,
      required String text,
      void Function()? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: index == 0 ? onTap : null,
          child: Container(
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
            ),
          ),
        ),
      ],
    );
  }

  Widget dashboardContainer(
      {required Color color,
      // required Color color2,
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
              color: Colors.white,
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
              color: Colors.white,
            ),
          ),
          Spacer(),
          Center(
              child: CustomText(
            text: count.toString(),
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ))
        ],
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  onTapLogout(context) async {
    AuthHelper().clearUserData();
    await SharedPreference().clearUserData();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
