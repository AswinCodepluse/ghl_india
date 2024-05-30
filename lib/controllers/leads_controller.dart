import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/models/filter_leads_model.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';

class LeadsDataController extends GetxController {
  var leadsList = <AllLeads>[].obs;
  var filterLeadsList = <FilterLeadsData>[].obs;
  var facebookLeads = <AllLeads>[].obs;
  var websiteLeads = <AllLeads>[].obs;
  var googleLeads = <AllLeads>[].obs;
  var leadPhoneNumbers = <String>[].obs;
  var searchLeadsList = <FilterLeadsData>[].obs;
  String leadType = "";
  TextEditingController searchCon = TextEditingController();
  var isLeads = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    // fetchAllLeadsData();

    super.onInit();
  }

  // fetchAllLeadsData() async {
  //   isLeads.value = true;
  //   var leadsResponse = await Dashboard().fetchLeads();
  //   leadsList.addAll(leadsResponse);
  //   facebookLeads.value = leadsResponse
  //       .where((n) => n.source == "Fb_leads_GHL India Asset")
  //       .toList();
  //   googleLeads.value =
  //       leadsResponse.where((n) => n.source == 'google').toList();
  //   websiteLeads.value =
  //       leadsResponse.where((n) => n.source == 'website').toList();
  //   for (int i = 0; i < leadsList.length; i++) {
  //     leadPhoneNumbers.add(leadsList[i].phoneNo!);
  //   }
//   isLeads.value = false;
//   update();
// }

  fetchAllLeadsData({required String filterBy, required String session}) async {
    isLeads.value = true;
    filterLeadsList.clear();
    leadPhoneNumbers.clear();
    var leadsResponse = await Dashboard()
        .fetchFilterLeads(filterBy: filterBy, session: session);
    filterLeadsList.addAll(leadsResponse.data!);
    filterLeadsList.forEach((lead) {
      leadPhoneNumbers.add(lead.phoneNo!);
    });
    isLeads.value = false;
  }

  fetchTodayFollowUpLeads({required int status}) async {
    isLeads.value = true;
    filterLeadsList.clear();
    leadPhoneNumbers.clear();
    var leadsResponse = await Dashboard()
        .fetchTodayFollowUpLeads(status: status);
    filterLeadsList.addAll(leadsResponse.data!);
    filterLeadsList.forEach((lead) {
      leadPhoneNumbers.add(lead.phoneNo!);
    });
    isLeads.value = false;
  }

  var colors = [
    'red',
    'blue',
    'orange',
    'green',
    'yellow',
    'purple',
    'pink',
    'cyan',
    'brown',
    'teal'
  ];

  Color getColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      case 'brown':
        return Colors.brown;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.black;
    }
  }

  searchLead(String str) {
    searchLeadsList.value = filterLeadsList
        .where((lead) => lead.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
    update();
  }

  clearSearchText() {
    searchLeadsList.value = [];
    searchCon.clear();
    update();
  }
}
