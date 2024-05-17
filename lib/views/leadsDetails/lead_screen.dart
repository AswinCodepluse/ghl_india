import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/views/dashboard/components/search_bar.dart';
import 'package:ghl_callrecoding/views/leadsDetails/leads_details.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key, required this.platforms});

  final String platforms;

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Get.find();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: widget.platforms == 'allLeads'
              ? "Leads"
              : widget.platforms == 'website'
                  ? "Website Leads"
                  : widget.platforms == "facebook"
                      ? "Facebook Leads"
                      : "Google Leads",
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child:
                searchBar(dashboardController.searchCon, dashboardController),
          ),
          Expanded(
            child: GetBuilder<DashboardController>(
              builder: (dashboardController) {
                return dashboardController.isLeads.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : dashboardController.searchCon.text.isNotEmpty &&
                            dashboardController.searchLeadsList.isEmpty
                        ? Center(
                            child: CustomText(
                            text: "No Search Lead Found",
                          ))
                        : ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount:
                                dashboardController.searchCon.text.isNotEmpty
                                    ? dashboardController.searchLeadsList.length
                                    : widget.platforms == "allLeads"
                                        ? dashboardController.leadsList.length
                                        : widget.platforms == "website"
                                            ? dashboardController
                                                .websiteLeads.length
                                            : widget.platforms == "facebook"
                                                ? dashboardController
                                                    .facebookLeads.length
                                                : dashboardController
                                                    .googleLeads.length,
                            itemBuilder: (context, index) {
                              final data = dashboardController
                                      .searchCon.text.isNotEmpty
                                  ? dashboardController.searchLeadsList[index]
                                  : widget.platforms == "allLeads"
                                      ? dashboardController.leadsList[index]
                                      : widget.platforms == "website"
                                          ? dashboardController
                                              .websiteLeads[index]
                                          : widget.platforms == "facebook"
                                              ? dashboardController
                                                  .facebookLeads[index]
                                              : dashboardController
                                                  .googleLeads[index];
                              final randomColor = dashboardController.colors[
                                  Random().nextInt(
                                      dashboardController.colors.length)];
                              return leadsContainer(
                                  data, randomColor, dashboardController);
                            });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget leadsContainer(AllLeads data, String randomColor,
      DashboardController dashboardController) {
    String firstLetter = data.name!.substring(0, 1).toUpperCase();
    String lastLetter =
        data.name!.substring(data.name!.length - 1).toUpperCase();
    return GestureDetector(
      onTap: ()async {
        var userName = await SharedPreference().getUserName();
        Get.to(
          () => LeadDetailsScreen(
            phoneNumber: data.phoneNo!,
            firstLetter: firstLetter,
            lastLetter: lastLetter,
            leadName: data.name!,
            leadId: data.id!,
            email: data.email!,
            userName: userName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  color: dashboardController.getColor(randomColor),
                  shape: BoxShape.circle),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    firstLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    lastLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: CustomText(
                      text: data.name ?? '',
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                    width: 220, child: CustomText(text: data.phoneNo ?? '')),
                SizedBox(width: 220, child: CustomText(text: data.email ?? '')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}