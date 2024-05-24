import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/controllers/leads_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/models/filter_leads_model.dart';
import 'package:ghl_callrecoding/views/dashboard/components/search_bar.dart';
import 'package:ghl_callrecoding/views/leadsDetails/leads_details.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen(
      {super.key,
      required this.platforms,
      required this.session,
      required this.filterBy});

  final String platforms;
  final String session;
  final String filterBy;

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  LeadsDataController leadsDataController = Get.put(LeadsDataController());

  @override
  void initState() {
    super.initState();
    leadsDataController.leadType = widget.platforms;
    print('+============================');
    print(widget.session);
    print(widget.platforms);
    print('+============================');
    leadsDataController.fetchAllLeadsData(
        filterBy: widget.platforms, session: widget.session);
  }

  @override
  Widget build(BuildContext context) {
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
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            // Obx(() {
            //   return
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: leadsDataController.filterLeadsList.isEmpty
                    ? Container()
                    : searchBar(
                        leadsDataController.searchCon, leadsDataController)
                // widget.platforms == "allLeads"
                //     ? leadsDataController.leadsList.isEmpty
                //         ? Container()
                //         : searchBar(
                //             leadsDataController.searchCon, leadsDataController)
                //     : widget.platforms == "website"
                //         ? leadsDataController.websiteLeads.isEmpty
                //             ? Container()
                //             : searchBar(leadsDataController.searchCon,
                //                 leadsDataController)
                //         : widget.platforms == "facebook"
                //             ? leadsDataController.facebookLeads.isEmpty
                //                 ? Container()
                //                 : searchBar(leadsDataController.searchCon,
                //                     leadsDataController)
                //             : leadsDataController.googleLeads.isEmpty
                //                 ? Container()
                //                 : searchBar(leadsDataController.searchCon,
                //                     leadsDataController),
                ),
            // }),
            Expanded(
                child:
                    // GetBuilder<LeadsDataController>(
                    //     builder: (leadsDataController) {
                    //       return
                    leadsDataController.isLeads.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : leadsDataController.searchCon.text.isNotEmpty &&
                                leadsDataController.searchLeadsList.isEmpty
                            ? Center(
                                child: CustomText(
                                text: "No Search Lead Found",
                              ))
                            : leadsDataController.filterLeadsList.isEmpty
                                ? Center(
                                    child: CustomText(
                                    text: "No Leads ${widget.filterBy} Leads Found",
                                  ))
                                : leadListViewBuilder()
                // leadListViewBuilder(),
                // leadsDataController.searchCon.text.isNotEmpty &&
                //             leadsDataController.searchLeadsList.isEmpty
                //         ? Center(
                //             child: CustomText(
                //             text: "No Search Lead Found",
                //           ))
                //         : widget.platforms == "allLeads"
                //             ? leadsDataController.leadsList.isEmpty
                //                 ? Center(
                //                     child: CustomText(
                //                     text: "No Leads Found",
                //                   ))
                //                 : leadListViewBuilder()
                //             : widget.platforms == "website"
                //                 ? leadsDataController.websiteLeads.isEmpty
                //                     ? Center(
                //                         child: CustomText(
                //                         text: "No WebsiteLeads Found",
                //                       ))
                //                     : leadListViewBuilder()
                //                 : widget.platforms == "facebook"
                //                     ? leadsDataController.facebookLeads.isEmpty
                //                         ? Center(
                //                             child: CustomText(
                //                             text: "No FaceBookLeads Found",
                //                           ))
                //                         : leadListViewBuilder()
                //                     : leadsDataController.googleLeads.isEmpty
                //                         ? Center(
                //                             child: CustomText(
                //                               text: "No GoogleLeads Found",
                //                             ),
                //                           )
                //                         : leadListViewBuilder();
                // },
                // ),
                )
          ],
        );
      }),
    );
  }

  Widget leadListViewBuilder() {
    return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: leadsDataController.searchCon.text.isNotEmpty
            ? leadsDataController.searchLeadsList.length
            : leadsDataController.filterLeadsList.length,
        // leadsDataController.searchCon.text.isNotEmpty
        //     ? leadsDataController.searchLeadsList.length
        //     : widget.platforms == "allLeads"
        //         ? leadsDataController.leadsList.length
        //         : widget.platforms == "website"
        //             ? leadsDataController.websiteLeads.length
        //             : widget.platforms == "facebook"
        //                 ? leadsDataController.facebookLeads.length
        //                 : leadsDataController.googleLeads.length,
        itemBuilder: (context, index) {
          final data = leadsDataController.searchCon.text.isNotEmpty
              ? leadsDataController.searchLeadsList[index]
              : leadsDataController.filterLeadsList[index];
          // leadsDataController.searchCon.text.isNotEmpty
          //     ? leadsDataController.searchLeadsList[index]
          //     : widget.platforms == "allLeads"
          //         ? leadsDataController.leadsList[index]
          //         : widget.platforms == "website"
          //             ? leadsDataController.websiteLeads[index]
          //             : widget.platforms == "facebook"
          //                 ? leadsDataController.facebookLeads[index]
          //                 : leadsDataController.googleLeads[index];
          final randomColor = leadsDataController
              .colors[Random().nextInt(leadsDataController.colors.length)];
          return leadsContainer(data, randomColor, leadsDataController);
        });
  }

  Widget leadsContainer(FilterLeadsData data, String randomColor,
      LeadsDataController leadsDataController) {
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
