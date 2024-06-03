import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/leads_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/filter_leads_model.dart';
import 'package:ghl_callrecoding/views/leadsDetails/leads_details.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget leadsContainer(
    FilterLeadsData data,
    String randomColor,
    LeadsDataController leadsDataController,
    String filterBy,
    int? status,
    double screenWidth) {
  String firstLetter = data.name!.substring(0, 1).toUpperCase();
  String lastLetter = data.name!.substring(data.name!.length - 1).toUpperCase();
  String icon = leadsDataController.sourceTypeIcon(data.source!);
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
              filterBy == "Call Later" ||
                      filterBy == "Interested" ||
                      filterBy == "KYC Fill"
                  ? SizedBox(
                      width: screenWidth / 1.89,
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
                      width: screenWidth / 1.89,
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
                    ),
              status != null && data.notes != null
                  ? SizedBox(
                      width: screenWidth / 1.89,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.note_alt,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: screenWidth/2.25,
                            child: CustomText(
                                text: data.notes ?? '',
                                fontSize: 12,
                                maxLines: 5,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),

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
