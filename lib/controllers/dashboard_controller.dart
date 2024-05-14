import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';

class DashboardController extends GetxController {
  var leadsList = <AllLeads>[].obs;
  var searchLeadsList = <AllLeads>[].obs;
  var leadPhoneNumbers = <String>[].obs;
  TextEditingController searchCon = TextEditingController();
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
  var isLeads = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchAll();
    super.onInit();
  }

  @override
  void onClose() {
    clearAll();
    // TODO: implement onClose
    super.onClose();
  }

  fetchAllLeadsData() async {
    isLeads.value = true;
    var leadsResponse = await Dashboard().fetchLeads();
    leadsList.addAll(leadsResponse);
    for (int i = 0; i < leadsList.length; i++) {
      leadPhoneNumbers.add(leadsList[i].phoneNo!);
    }
    isLeads.value = false;
    update();
  }

  fetchAll() {
    fetchAllLeadsData();
  }

  clearAll() {
    leadsList.clear();
  }

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
    searchLeadsList.value = leadsList
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
