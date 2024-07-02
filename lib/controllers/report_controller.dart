import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/repositories/report_repository.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:toast/toast.dart';

class ReportController extends GetxController {
  TextEditingController reportCon = TextEditingController();
  RxBool disable = false.obs;

  isDisable() {
    if (reportCon.text != '') {
      disable.value = true;
    } else {
      disable.value = false;
    }
    update();
  }

  onTapSave(BuildContext context, int leadId) async {
    var reportResponse = await ReportRepository()
        .createReport(leadId: leadId.toString(), reportNotes: reportCon.text);
    ToastComponent.showDialog(reportResponse.message!,
        gravity: Toast.center, duration: Toast.lengthLong);
    if (reportResponse.result == true) {
      reportCon.clear();
      isDisable();
      Navigator.pop(context);
    }
  }

  onTapCancel(BuildContext context) {
    reportCon.clear();
    isDisable();
    Navigator.pop(context);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
