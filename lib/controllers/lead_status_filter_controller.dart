import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/leads_filter_models.dart';
import 'package:ghl_callrecoding/repositories/lead_status_repository.dart';
import 'package:intl/intl.dart';

class LeadStatusFilterController extends GetxController {
  RxList<UserLeadsDetails> filterLeadStatusList = <UserLeadsDetails>[].obs;
  RxList<UserLeadsDetails> searchLeadsList = <UserLeadsDetails>[].obs;
  TextEditingController searchCon = TextEditingController();
  int statusId = 0;
  RxBool loadingState = false.obs;
  var formattedDate = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchFilterLeadStatus(statusId);
  // }

  fetchFilterLeadStatus(int statusIds, String filterBy) async {
    loadingState.value = true;
    var response = await LeadStatusRepository()
        .fetchFilterLeadStatus(id: statusIds, filterBy: filterBy);
    filterLeadStatusList.addAll(response.data!);
    loadingState.value = false;
  }

  RxString getCurrentDate() {
    // Get the current date
    DateTime now = DateTime.now();

    // Format the date as a string
    formattedDate.value = DateFormat('dd-MM-yyyy hh:mm:a').format(now);

    return formattedDate;
  }
  // Future<RxList<UserLeadsDetails>> fetchAndSortFilterLeadStatus(
  //     int statusIds, String filterBy) async {
  //   loadingState.value = true;
  //   var response = await LeadStatusRepository().fetchFilterLeadStatus(id: statusIds, filterBy: filterBy);
  //   filterLeadStatusList.addAll(response.data!);
  //   // Sort the list based on date in ascending order
  //   filterLeadStatusList.sort((a, b) => formattedDate.value.compareTo(b.nextFollowUpDate ?? ''));
  //   loadingState.value = false;
  //   return filterLeadStatusList;
  // }

  searchLead(String str) {
    searchLeadsList.value = filterLeadStatusList
        .where((lead) => lead.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
    print(searchLeadsList);
  }

  clearSearchText() {
    searchLeadsList.value = [];
    searchCon.clear();
    update();
  }
}
