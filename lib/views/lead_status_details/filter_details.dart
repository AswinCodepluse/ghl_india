import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_status_filter_controller.dart';
import 'package:ghl_callrecoding/controllers/leads_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/views/lead_status_details/widget/search_bar.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

import '../../models/leads_filter_models.dart';
import '../leadsDetails/leads_details.dart';

class LeadDataFilterStatus extends StatefulWidget {
  LeadDataFilterStatus(
      {super.key,
      required this.statusId,
      required this.status,
      required this.filterBy});

  final int statusId;
  final String status;
  final String filterBy;

  @override
  State<LeadDataFilterStatus> createState() => _LeadDataFilterStatusState();
}

class _LeadDataFilterStatusState extends State<LeadDataFilterStatus> {
  final LeadStatusFilterController leadStatusFilterController =
      Get.put(LeadStatusFilterController());

  final LeadsDataController leadsDataController =
      Get.put(LeadsDataController());

  @override
  void initState() {
    // TODO: implement initState
    leadStatusFilterController.getCurrentDate();
    leadStatusFilterController.fetchFilterLeadStatus(
        widget.statusId, widget.filterBy);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    leadStatusFilterController.filterLeadStatusList.clear();
    leadStatusFilterController.searchCon.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('statusId   ${widget.statusId}');
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.transparent,
        title: CustomText(text: widget.status),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(() {
        return leadStatusFilterController.loadingState.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : Obx(() {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: leadStatusFilterController
                              .descendingOrderStatusList.isEmpty
                          ? Container()
                          : searchBar(leadStatusFilterController.searchCon,
                              leadStatusFilterController),
                    ),
                    Expanded(
                      child:
                          leadStatusFilterController
                                  .descendingOrderStatusList.isEmpty
                              ? Center(
                                  child: CustomText(
                                    text: "No Leads Available For This Status",
                                  ),
                                )
                              : leadStatusFilterController
                                          .searchCon.text.isNotEmpty &&
                                      leadStatusFilterController
                                          .searchLeadsList.isEmpty
                                  ? Center(
                                      child: CustomText(
                                      text: "No Search Lead Found",
                                    ))
                                  : ListView.builder(
                                      keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .onDrag,
                                      itemCount:
                                          leadStatusFilterController
                                                  .searchCon.text.isNotEmpty
                                              ? leadStatusFilterController
                                                  .searchLeadsList.length
                                              : leadStatusFilterController
                                                  .descendingOrderStatusList
                                                  .length,
                                      // leadStatusFilterController
                                      //         .filterLeadStatusList.length,
                                      itemBuilder: (context, index) {
                                        final data = leadStatusFilterController
                                                .searchCon.text.isNotEmpty
                                            ? leadStatusFilterController
                                                .searchLeadsList[index]
                                            : leadStatusFilterController
                                                    .descendingOrderStatusList[
                                                index];
                                        final randomColor =
                                            leadsDataController.colors[Random()
                                                .nextInt(leadsDataController
                                                    .colors.length)];
                                        return leadsContainer(
                                            data, randomColor, screenWidth);
                                      }),
                    )
                  ],
                );
              });
      }),
    );
  }

  Widget leadsContainer(
      UserLeadsDetails data, String randomColor, double screenWidth) {
    String firstLetter = data.name!.substring(0, 1).toUpperCase();
    String lastLetter =
        data.name!.substring(data.name!.length - 1).toUpperCase();
    String icon = leadsDataController.sourceTypeIcon(data.source!);

    return GestureDetector(
      onTap: () async {
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
                  color: leadsDataController.getColor(randomColor),
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
                  width: screenWidth / 1.89,
                  child: CustomText(
                      text: data.name ?? '',
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: screenWidth / 1.89,
                  child: CustomText(text: data.phoneNo ?? ''),
                ),
                SizedBox(
                  width: screenWidth / 1.89,
                  child: CustomText(
                    text: data.email ?? '',
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                data.statusInt == 3 ||
                        data.statusInt == 2 ||
                        data.statusInt == 11 ||
                        data.statusInt == 13
                    ? SizedBox()
                    : SizedBox(
                        width: screenWidth / 1.89,
                        child: Row(
                          children: [
                            data.statusInt == 1
                                ? Icon(
                                    Icons.timer,
                                    color: Colors.red,
                                  )
                                : data.nextFollowUpDate != null
                                    ? Icon(
                                        Icons.date_range,
                                        color: Colors.red,
                                      )
                                    : SizedBox(),
                            SizedBox(
                              width: 5,
                            ),
                            data.statusInt == 1
                                ? CustomText(
                                    text: data.createdAt ?? '',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)
                                : data.nextFollowUpDate != null
                                    ? CustomText(
                                        text: data.nextFollowUpDate ?? '',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)
                                    : SizedBox(),
                          ],
                        ),
                      )
              ],
            ),
            Spacer(),
            Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image(
                  image: AssetImage(icon),
                )),
          ],
        ),
      ),
    );
  }
}
