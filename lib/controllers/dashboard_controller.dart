import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';

class DashboardController extends GetxController {
  var leadsList = <AllLeads>[].obs;
  var colors = ['red', 'blue', 'orange', 'green', 'yellow', 'purple', 'pink', 'cyan', 'brown', 'teal'];
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
    isLeads.value = false;
    update();
  }

  fetchAll() {
    fetchAllLeadsData();
  }

  clearAll() {
    leadsList.clear();
  }
}
