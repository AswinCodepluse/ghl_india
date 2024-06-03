import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/controllers/leads_controller.dart';
import 'package:ghl_callrecoding/views/dashboard/components/search_bar.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/leads_container.dart';
import 'package:ghl_callrecoding/views/recording_files/file_screen.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen(
      {super.key,
      required this.platforms,
      required this.session,
      required this.filterBy,
      this.status});

  final String platforms;
  final String session;
  final String filterBy;
  final int? status;

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  LeadsDataController leadsDataController = Get.put(LeadsDataController());
  FileController fileController = Get.put(FileController());

  @override
  void initState() {
    super.initState();
    leadsDataController.leadType = widget.platforms;
    if (widget.status != null) {
      leadsDataController.fetchTodayFollowUpLeads(status: widget.status!);
    } else {
      leadsDataController.fetchAllLeadsData(
          filterBy: widget.platforms, session: widget.session);
    }
    Future.delayed(Duration(seconds: 1), () {
      fileController.checkPermission();
    });
  }

  @override
  void dispose() {
    leadsDataController.searchCon.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => FileScreen());
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.file_copy),
            ),
          ),
        ],
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
                                  : widget.platforms == 'google'
                                      ? "Google Leads"
                                      : widget.status == 4
                                          ? "Followup Call Later"
                                          : widget.status == 5
                                              ? "Followup Interested"
                                              : "Followup KYC Fill",
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
                          color: Colors.red,
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
                            : leadListViewBuilder(screenWidth),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget leadListViewBuilder(double screenWidth) {
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
          return leadsContainer(
              data, randomColor, leadsDataController, widget.platforms,widget.status,screenWidth);
        });
  }
}
