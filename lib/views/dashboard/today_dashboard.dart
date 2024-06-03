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

class TodayDashBoardScreen extends StatefulWidget {
  TodayDashBoardScreen({
    super.key,
    required this.seasons,
  });

  final String seasons;

  @override
  State<TodayDashBoardScreen> createState() => _TodayDashBoardScreenState();
}

class _TodayDashBoardScreenState extends State<TodayDashBoardScreen> {
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
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth / 18,
                        vertical: screenWidth / 45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              iconColor: Colors.white),
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
                        widget.seasons == "today"
                            ? Wrap(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenWidth / 45,top: screenWidth / 24,),
                                    child: CustomText(text: "Today's Followup"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenWidth / 45),
                                    child: InkWell(
                                      child: whatsappContainer(
                                        screenWidth: screenWidth,
                                        icon:
                                            "assets/image/call_later_icon.png",
                                        text: "Call Later",
                                        count: dashboardController
                                            .followUpTodayCallLater.value,
                                      ),
                                      onTap: () {
                                        Get.to(
                                          () => LeadScreen(
                                            platforms: "Call Later",
                                            session: widget.seasons,
                                            filterBy: "Call Later",
                                            status: 4,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenWidth / 45),
                                    child: InkWell(
                                      child: whatsappContainer(
                                        screenWidth: screenWidth,
                                        icon:
                                            "assets/image/interested_icon.png",
                                        text: "Interested",
                                        count: dashboardController
                                            .followUpTodayInterested.value,
                                      ),
                                      onTap: () {
                                        Get.to(
                                          () => LeadScreen(
                                            platforms: "Interested",
                                            session: widget.seasons,
                                            filterBy: "Interested",
                                            status: 5,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    child: whatsappContainer(
                                      screenWidth: screenWidth,
                                      icon: "assets/image/kyc_icon.png",
                                      text: "KYC Fill",
                                      count: dashboardController
                                          .followUpTodayKYCFill.value,
                                    ),
                                    onTap: () {
                                      Get.to(
                                        () => LeadScreen(
                                          platforms: "KYC Fill",
                                          session: widget.seasons,
                                          filterBy: "KYC Fill",
                                          status: 7,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Container(),
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
                                // color: randomColor
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
