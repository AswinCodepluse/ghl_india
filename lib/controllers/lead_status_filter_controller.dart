import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/leads_filter_models.dart';
import 'package:ghl_callrecoding/repositories/lead_status_repository.dart';

class LeadStatusFilterController extends GetxController {
  RxList<UserLeadsDetails> filterLeadStatusList = <UserLeadsDetails>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFilterLeadStatus();
  }

  fetchFilterLeadStatus() async {
    var response = await LeadStatusRepository().fetchFilterLeadStatus();
    filterLeadStatusList.addAll(response.data!);
    print('================');
    print(response);
  }
}
