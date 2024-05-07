import 'package:get/get.dart';

class LeadsController extends GetxController {
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

  fetchAllLeadsDatas() async {
    isLeads.value = true;
    // var leadsResponse = await Dashboard().fetchLeads();
    // leadsList.addAll(leadsResponse);
    isLeads.value = false;
    update();
  }

  fetchAll() {
    fetchAllLeadsDatas();
  }

  clearAll() {
    // leadsList.clear();
  }
}