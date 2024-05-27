import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/leads_controller.dart';
import 'package:ghl_callrecoding/views/dashboard/components/search_bar.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/leads_container.dart';
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
                      : widget.platforms == 'ai_chat'
                          ? "AI Chats"
                          : widget.platforms == 'whatsapp'
                              ? "Whatsapp"
                              : widget.platforms == 'dp'
                                  ? "DP"
                                  : "Google Leads",
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(
        () {
          return Column(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: leadsDataController.filterLeadsList.isEmpty
                      ? Container()
                      : searchBar(
                          leadsDataController.searchCon, leadsDataController)),
              Expanded(
                child: leadsDataController.isLeads.value
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
                            : leadListViewBuilder(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget leadListViewBuilder() {
    return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: leadsDataController.searchCon.text.isNotEmpty
            ? leadsDataController.searchLeadsList.length
            : leadsDataController.filterLeadsList.length,
        itemBuilder: (context, index) {
          final data = leadsDataController.searchCon.text.isNotEmpty
              ? leadsDataController.searchLeadsList[index]
              : leadsDataController.filterLeadsList[index];
          final randomColor = leadsDataController
              .colors[Random().nextInt(leadsDataController.colors.length)];
          return leadsContainer(data, randomColor, leadsDataController);
        });
  }
}
