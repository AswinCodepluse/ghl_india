import 'package:get/get.dart';
import 'package:ghl_callrecoding/repositories/time_line_repository.dart';

class TimeLineController extends GetxController {
  var activeTimeLineList = [].obs;
  var firstFollowupDate = "".obs;
  var firstOldStatus = "".obs;
  var leadId = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchTimeLine(leadId.value);
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  fetchTimeLine(int leadId) async {
    activeTimeLineList.clear();
    var response = await TimeLineRepository().fetchTimeLine(leadId);
    activeTimeLineList.addAll(response);
    if (activeTimeLineList.isNotEmpty) {
      firstOldStatus.value = activeTimeLineList.first.oldStatus ?? '';
      firstFollowupDate.value = activeTimeLineList.first.nextFollowUpDate ?? '';
    }
  }
}
