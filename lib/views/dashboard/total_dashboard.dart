import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/views/dashboard/components/dashboard_container.dart';
import 'package:ghl_callrecoding/views/dashboard/components/round_container.dart';
import 'package:ghl_callrecoding/views/dashboard/components/whatsapp_container.dart';
import 'package:ghl_callrecoding/views/lead_status_details/filter_details.dart';
import 'package:ghl_callrecoding/views/leadsDetails/lead_screen.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class TotalDashBoardScreen extends StatefulWidget {
  TotalDashBoardScreen({
    super.key,
    required this.seasons,
  });

  final String seasons;

  @override
  State<TotalDashBoardScreen> createState() => _TotalDashBoardScreenState();
}

class _TotalDashBoardScreenState extends State<TotalDashBoardScreen> {
  final DashboardController dashboardController = Get.find();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.leadSeasons = widget.seasons;
      dashboardController.fetchDashboardData(widget.seasons);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Obx(() {
                              return InkWell(
                                child: dashboardContainer(
                                    screenWidth: screenWidth,
                                    text: "Total Leads",
                                    icon: "assets/image/dashboard_icon_1.png",
                                    count: dashboardController.totalLead.value),
                                onTap: () {
                                  Get.to(() => LeadScreen(
                                        platforms: "allLeads",
                                        session: widget.seasons,
                                        filterBy: "total",
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
                                    screenWidth: screenWidth,
                                    text: "Website Lead",
                                    icon: "assets/image/dashboard_icon_2.png",
                                    count:
                                        dashboardController.websiteLead.value),
                                onTap: () {
                                  Get.to(() => LeadScreen(
                                        platforms: "website",
                                        session: widget.seasons,
                                        filterBy: "website",
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
                                    screenWidth: screenWidth,
                                    text: "Facebook Lead",
                                    icon: "assets/image/dashboard_icon_3.png",
                                    count:
                                        dashboardController.facebookLead.value),
                                onTap: () {
                                  Get.to(() => LeadScreen(
                                        platforms: "facebook",
                                        session: widget.seasons,
                                        filterBy: "facebook",
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
                                    screenWidth: screenWidth,
                                    text: "Google Lead",
                                    icon: "assets/image/google_drive_icon.png",
                                    count:
                                        dashboardController.googleLead.value),
                                onTap: () {
                                  Get.to(() => LeadScreen(
                                        platforms: "google",
                                        session: widget.seasons,
                                        filterBy: "google",
                                      ));
                                },
                              );
                            })),
                          ],
                        ),
                        SizedBox(
                          height: screenWidth / 24,
                        ),
                        InkWell(
                          child: whatsappContainer(
                            screenWidth: screenWidth,
                            icon: "assets/image/dashboard_whatsapp-icon.png",
                            text: "Whatsapp",
                            count: dashboardController.whatsAppLead.value,
                            color: MyTheme.mainColor,
                            iconColor: Colors.white
                            // color:Color(0XFFBA4A00)
                          ),
                          onTap: () {
                            Get.to(
                              () => LeadScreen(
                                platforms: "whatsapp",
                                session: widget.seasons,
                                filterBy: "whatsapp",
                              ),
                            );
                          },
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
                              crossAxisCount: 3,
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
                                          LeadDataFilterStatus(
                                        status: status,
                                        statusId: statusId,
                                        filterBy: widget.seasons,
                                      ),
                                    ),
                                  );
                                },
                              );
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
    );
  }
}
