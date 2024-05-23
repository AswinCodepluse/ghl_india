import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/leads_filter_models.dart';
import 'package:ghl_callrecoding/repositories/lead_status_repository.dart';

class LeadStatusFilterController extends GetxController {
  RxList<UserLeadsDetails> filterLeadStatusList = <UserLeadsDetails>[].obs;
  RxList<UserLeadsDetails> searchLeadsList = <UserLeadsDetails>[].obs;
  TextEditingController searchCon = TextEditingController();
  int statusId = 0;
  RxBool loadingState = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchFilterLeadStatus(statusId);
  // }

  fetchFilterLeadStatus(int statusIds) async {
    loadingState.value = true;
    var response =
        await LeadStatusRepository().fetchFilterLeadStatus(id: statusIds);
    filterLeadStatusList.addAll(response.data!);
    loadingState.value = false;
  }

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
