import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/leads_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/filter_leads_model.dart';
import 'package:ghl_callrecoding/views/leadsDetails/leads_details.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget leadsContainer(FilterLeadsData data, String randomColor,
    LeadsDataController leadsDataController, String filterBy) {
  String firstLetter = data.name!.substring(0, 1).toUpperCase();
  String lastLetter = data.name!.substring(data.name!.length - 1).toUpperCase();
  SharedPreference sharedPreference = SharedPreference();
  return GestureDetector(
    onTap: () async {
      var userName = await sharedPreference.getUserName();
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
                width: 220,
                child: CustomText(
                    text: data.name ?? '',
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 220,
                child: CustomText(text: data.phoneNo ?? ''),
              ),
              SizedBox(
                width: 220,
                child: CustomText(
                  text: data.email ?? '',
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              filterBy == "Call Later" ||
                      filterBy == "Interested" ||
                      filterBy == "KYC Fill"
                  ? SizedBox(
                      width: 220,
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CustomText(
                              text: data.followupDate ?? '',
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                    )
                  : Container(
                      width: 220,
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            text: data.createAt ?? '',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ],
      ),
    ),
  );
}
