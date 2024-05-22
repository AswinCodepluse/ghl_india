import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';

class LeadsDataController extends GetxController {
  var leadsList = <AllLeads>[].obs;
  var facebookLeads = <AllLeads>[].obs;
  var websiteLeads = <AllLeads>[].obs;
  var googleLeads = <AllLeads>[].obs;
  var leadPhoneNumbers = <String>[].obs;
  var searchLeadsList = <AllLeads>[].obs;
  String leadType = "";
  TextEditingController searchCon = TextEditingController();
  var isLeads = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    // fetchAllLeadsData();

    super.onInit();
  }

  fetchAllLeadsData() async {
    isLeads.value = true;
    var leadsResponse = await Dashboard().fetchLeads();
    leadsList.addAll(leadsResponse);
    facebookLeads.value = leadsResponse
        .where((n) => n.source == "Fb_leads_GHL India Asset")
        .toList();
    googleLeads.value =
        leadsResponse.where((n) => n.source == 'google').toList();
    websiteLeads.value =
        leadsResponse.where((n) => n.source == 'website').toList();
    for (int i = 0; i < leadsList.length; i++) {
      leadPhoneNumbers.add(leadsList[i].phoneNo!);
    }

    isLeads.value = false;
    update();
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
    if (leadType == "website") {
      searchLeadsList.value = websiteLeads
          .where(
              (lead) => lead.name!.toLowerCase().startsWith(str.toLowerCase()))
          .toList();
    } else if (leadType == "facebook") {
      searchLeadsList.value = facebookLeads
          .where(
              (lead) => lead.name!.toLowerCase().startsWith(str.toLowerCase()))
          .toList();
    } else if (leadType == "google") {
      searchLeadsList.value = googleLeads
          .where(
              (lead) => lead.name!.toLowerCase().startsWith(str.toLowerCase()))
          .toList();
    } else {
      searchLeadsList.value = leadsList
          .where(
              (lead) => lead.name!.toLowerCase().startsWith(str.toLowerCase()))
          .toList();
    }
    update();
  }

  clearSearchText() {
    searchLeadsList.value = [];
    searchCon.clear();
    update();
  }
}
