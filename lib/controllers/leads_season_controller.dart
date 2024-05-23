import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/leads_filter_models.dart';
import 'package:ghl_callrecoding/repositories/lead_status_repository.dart';

class LeadsSeasonController extends GetxController{
  RxList<UserLeadsDetails> filterLeadSeasonList = <UserLeadsDetails>[].obs;
  RxBool loadingState = false.obs;

  fetchFilterLeadSeason() async {
    loadingState.value = true;
    var response =
    await LeadStatusRepository().fetchFilterLeadsSeasons();
    filterLeadSeasonList.addAll(response.data!);
    loadingState.value = false;
    print('================');
    print(response);
  }
}