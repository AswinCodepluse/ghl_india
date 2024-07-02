import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/sub_title_row.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/title_row.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget detailContainer(LeadsController leadsController) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: leadsController.shadow),
    margin: EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => leadsController.isInvestor.value == 1
              ? CustomText(
                  text: "Investor",
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                )
              : SizedBox(),
        ),
        SizedBox(
          height: 15,
        ),
        titleRow(firstTitle: "Source", secondTitle: "Language"),
        SizedBox(
          height: 10,
        ),
        Obx(
          () => subTitleRow(
              firstSubTitle: leadsController.leadDetailsData.value.source ?? "",
              secondSubTitle:
                  leadsController.leadDetailsData.value.language ?? "",
              firstIcon: Icons.location_on_sharp,
              secondIcon: Icons.language),
        ),
        SizedBox(
          height: 15,
        ),
        titleRow(firstTitle: "Status", secondTitle: "Occupation"),
        SizedBox(
          height: 10,
        ),
        Obx(
          () => subTitleRow(
              firstSubTitle: leadsController.leadDetailsData.value.status ?? "",
              secondSubTitle:
                  leadsController.leadDetailsData.value.occupation ?? "",
              firstIcon: Icons.circle_rounded,
              secondIcon: Icons.work),
        ),
        SizedBox(
          height: 15,
        ),
        titleRow(firstTitle: "Designation", secondTitle: "Planning"),
        SizedBox(
          height: 10,
        ),
        Obx(
          () => subTitleRow(
              firstSubTitle:
                  leadsController.leadDetailsData.value.designation ?? "",
              secondSubTitle:
                  leadsController.leadDetailsData.value.planning ?? '',
              firstIcon: Icons.cases_outlined,
              secondIcon: Icons.alarm),
        ),
        SizedBox(
          height: 15,
        ),
        titleRow(firstTitle: "Created On", secondTitle: "Updated On"),
        SizedBox(
          height: 10,
        ),
        Obx(
          () => subTitleRow(
              firstSubTitle:
                  leadsController.leadDetailsData.value.createdDate ?? '',
              secondSubTitle:
                  leadsController.leadDetailsData.value.lastUpdatedDate ?? '',
              firstIcon: Icons.calendar_month,
              secondIcon: Icons.calendar_month),
        ),
        SizedBox(
          height: 15,
        ),
        titleRow(firstTitle: "Interest", secondTitle: "Assigned"),
        SizedBox(
          height: 10,
        ),
        Obx(
          () => subTitleRow(
              firstSubTitle:
                  leadsController.leadDetailsData.value.interest ?? "",
              secondSubTitle:
                  leadsController.leadDetailsData.value.assigned ?? "",
              firstIcon: Icons.interests,
              secondIcon: Icons.work),
        ),
        SizedBox(
          height: 15,
        ),
        titleRow(firstTitle: "City", secondTitle: "Created At"),
        SizedBox(
          height: 10,
        ),
        Obx(
          () => subTitleRow(
              firstSubTitle: leadsController.leadDetailsData.value.city ?? "",
              secondSubTitle:
                  leadsController.leadDetailsData.value.createdAt ?? '',
              firstIcon: Icons.location_city,
              secondIcon: Icons.alarm_on_outlined),
        ),
      ],
    ),
  );
}
