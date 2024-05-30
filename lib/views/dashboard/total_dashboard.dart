import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
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
                              color: Colors.green,
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
                              color: Colors.pink,
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
                              color: Color(0xFF7569DE),
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
                              color: Color(0xFFF3C41F),
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
                  // Row(
                  //   children: [
                  //     Expanded(child: Obx(() {
                  //       return InkWell(
                  //         child: dashboardContainer(
                  //             color: Color(0xFF970652),
                  //             screenWidth: screenWidth,
                  //             text: "AI Chat",
                  //             icon: "assets/image/ai_image.png",
                  //             count: dashboardController.aiLead.value),
                  //         onTap: () {
                  //           Get.to(
                  //                 () => LeadScreen(
                  //               platforms: "ai_chat",
                  //               session: widget.seasons,
                  //               filterBy: "ai_chat",
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     })),
                  //     SizedBox(
                  //       width: screenWidth / 24,
                  //     ),
                  //     Expanded(child: Obx(() {
                  //       return InkWell(
                  //         child: dashboardContainer(
                  //             color: Color(0xFF2C3E50),
                  //             screenWidth: screenWidth,
                  //             text: "DP",
                  //             icon: "assets/image/dp_images.png",
                  //             count: dashboardController.dpLead.value),
                  //         onTap: () {
                  //           Get.to(
                  //                 () => LeadScreen(
                  //               platforms: "dp",
                  //               session: widget.seasons,
                  //               filterBy: "dp",
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     })),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: screenWidth / 24,
                  // ),
                  InkWell(
                    child: whatsappContainer(
                        screenWidth: screenWidth,
                        icon: "assets/image/whatsapp_icon.png",
                        text: "Whatsapp",
                        count: dashboardController.whatsAppLead.value,
                        color: Color(0XFFBA4A00)),
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
                                      LeadDataFilterStatus(
                                        status: status,
                                        statusId: statusId,
                                        filterBy: widget.seasons,
                                      ),
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

  Widget whatsappContainer({
    required double screenWidth,
    required String icon,
    required String text,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth / 24),
      height: screenWidth / 7,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(screenWidth / 36),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: screenWidth / 14,
                width: screenWidth / 14,
                child: Image(
                  image: AssetImage(icon),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: screenWidth / 30,
              ),
              FittedBox(
                child: CustomText(
                  text: text,
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth / 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          FittedBox(
            child: CustomText(
              text: count.toString(),
              fontSize: screenWidth / 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
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
      height: screenWidth / 3.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: screenWidth / 14,
                width: screenWidth / 14,
                child: Image(
                  image: AssetImage(icon),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: screenWidth / 15,
              ),
              FittedBox(
                child: CustomText(
                  text: count.toString(),
                  fontSize: screenWidth / 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenWidth / 44,
          ),
          FittedBox(
            child: CustomText(
              text: text,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth / 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(screenWidth / 36),
      ),
    );
  }
}
