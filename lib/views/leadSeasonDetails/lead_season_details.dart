import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/leads_season_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/leads_filter_models.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

import '../leadsDetails/leads_details.dart';

class LeadSeasonDetails extends StatefulWidget {
  const LeadSeasonDetails({super.key});

  @override
  State<LeadSeasonDetails> createState() => _LeadSeasonDetailsState();
}

class _LeadSeasonDetailsState extends State<LeadSeasonDetails> {
  final LeadsSeasonController leadsSeasonController =
      Get.put(LeadsSeasonController());

  @override
  void initState() {
    // TODO: implement initState
    leadsSeasonController.fetchFilterLeadSeason();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: CustomText(text: "Today Leads"),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(() {
        return leadsSeasonController.loadingState.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: leadsSeasonController.filterLeadSeasonList.isEmpty
                        ? Center(
                            child: CustomText(
                              text: "No Leads Available For This Session",
                            ),
                          )
                        : ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: leadsSeasonController
                                .filterLeadSeasonList.length,
                            itemBuilder: (context, index) {
                              final data = leadsSeasonController
                                  .filterLeadSeasonList[index];
                              return leadsContainer(data);
                            }),
                  )
                ],
              );
      }),
    );
  }

  Widget leadsContainer(UserLeadsDetails data) {
    String firstLetter = data.name!.substring(0, 1).toUpperCase();
    String lastLetter =
        data.name!.substring(data.name!.length - 1).toUpperCase();
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
                  color: Colors.red,
                  // color: leadStatusFilterController.getColor(randomColor),
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
                  width: 220,
                  child: CustomText(text: data.phoneNo ?? ''),
                ),
                SizedBox(
                  width: 220,
                  child: CustomText(text: data.email ?? ''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
