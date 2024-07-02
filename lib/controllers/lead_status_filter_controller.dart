import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/leads_filter_models.dart';
import 'package:ghl_callrecoding/repositories/lead_status_repository.dart';
import 'package:intl/intl.dart';

class LeadStatusFilterController extends GetxController {
  RxList<UserLeadsDetails> descendingOrderStatusList = <UserLeadsDetails>[].obs;
  RxList<UserLeadsDetails> filterLeadStatusList = <UserLeadsDetails>[].obs;
  RxList<UserLeadsDetails> searchLeadsList = <UserLeadsDetails>[].obs;
  List<UserLeadsDetails> nullDateList = <UserLeadsDetails>[];
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
    descendingOrderStatusList.clear();
    nullDateList.clear();
    var response = await LeadStatusRepository()
        .fetchFilterLeadStatus(id: statusIds, filterBy: filterBy);
    filterLeadStatusList.addAll(response.data!);
    for (int i = 0; i < filterLeadStatusList.length; i++) {
      if (filterLeadStatusList[i].nextFollowUpDate != null) {
        descendingOrderStatusList.add(filterLeadStatusList[i]);
      } else {
        nullDateList.add(filterLeadStatusList[i]);
      }
    }
    if (descendingOrderStatusList.isNotEmpty) {
      DateFormat dateFormat = DateFormat('dd-MM-yyyy hh:mm:a');
      for (int j = 0; j < descendingOrderStatusList.length - 1; j++) {
        for (int k = j + 1; k < descendingOrderStatusList.length; k++) {
          DateTime dateJ =
              dateFormat.parse(descendingOrderStatusList[j].nextFollowUpDate!);
          DateTime dateK =
              dateFormat.parse(descendingOrderStatusList[k].nextFollowUpDate!);
          if (dateJ.isBefore(dateK)) {
            var temp = descendingOrderStatusList[j];
            descendingOrderStatusList[j] = descendingOrderStatusList[k];
            descendingOrderStatusList[k] = temp;
          }
        }
      }
    }
    descendingOrderStatusList.addAll(nullDateList);
    loadingState.value = false;
  }

  RxString getCurrentDate() {
    DateTime now = DateTime.now();
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
        .where((lead) =>
            lead.name!.toLowerCase().startsWith(str.toLowerCase()) ||
            lead.phoneNo!.toLowerCase().startsWith(str.toLowerCase()) ||
            lead.email!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
    print(searchLeadsList);
  }

  clearSearchText() {
    searchLeadsList.value = [];
    searchCon.clear();
    update();
  }
}
