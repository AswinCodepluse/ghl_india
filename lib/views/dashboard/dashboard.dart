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
    final double screenWidth = MediaQuery.of(context).size.width;
    print("screenWidth $screenWidth");
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
                                    screenWidth: screenWidth,
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
                              width: screenWidth / 24,
                            ),
                            Expanded(child: Obx(() {
                              return InkWell(
                                child: dashboardContainer(
                                    color: Colors.red,
                                    screenWidth: screenWidth,
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
                          height: screenWidth / 24,
                        ),
                        Row(
                          children: [
                            Expanded(child: Obx(() {
                              return InkWell(
                                child: dashboardContainer(
                                    color: Color(0xFF7569DE),
                                    screenWidth: screenWidth,
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
                              width: screenWidth / 24,
                            ),
                            Expanded(child: Obx(() {
                              return InkWell(
                                child: dashboardContainer(
                                    color: Color(0xFFF3C41F),
                                    screenWidth: screenWidth,
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
                          height: screenWidth / 24,
                        ),
                        Obx(() {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: screenWidth / 36,
                              crossAxisSpacing: screenWidth / 36,
                              childAspectRatio: 1.0,
                            ),
                            itemCount:
                                dashboardController.dashboardCountList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  dashboardController.dashboardCountList[index];
                              int statusId = dashboardController
                                  .dashboardCountList[index].id;
                              String status = data.name;
                              final randomColor = dashboardController.colors[
                                  Random().nextInt(
                                      dashboardController.colors.length)];
                              return roundContainer(
                                  screenWidth: screenWidth,
                                  count: data.count!,
                                  text: data.name!,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LeadDatasFilterStatus(
                                                status: status,
                                                statusId: statusId),
                                      ),
                                    );
                                  },
                                  color: randomColor);
                            },
                          );
                        }),
                        SizedBox(
                          height: screenWidth / 24,
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
      String? color,
      required double screenWidth,
      required String text,
      required void Function() onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: screenWidth / 7.2,
            width: screenWidth / 7.2,
            child: Center(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    text: count.toString(),
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth / 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: dashboardController.getColor(color!),
                shape: BoxShape.circle),
          ),
        ),
        SizedBox(
          height: screenWidth / 120,
        ),
        SizedBox(
          width: screenWidth / 5.3,
          child: Center(
            child: FittedBox(
              child: CustomText(
                text: text,
                fontSize: screenWidth / 27.7,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget dashboardContainer(
      {required Color color,
      required double screenWidth,
      required String text,
      required int count,
      required String icon}) {
    return Container(
      padding: EdgeInsets.all(screenWidth / 24),
      height: screenWidth / 2.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenWidth / 12,
            width: screenWidth / 12,
            child: Image(
              image: AssetImage(icon),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: screenWidth / 36,
          ),
          FittedBox(
            child: CustomText(
              text: text,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth / 18,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Center(
              child: FittedBox(
            child: CustomText(
              text: count.toString(),
              fontSize: screenWidth / 11.25,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ))
        ],
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(screenWidth / 36),
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
