import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/report_controller.dart';
import 'package:ghl_callrecoding/utils/custom_button.dart';
import 'package:ghl_callrecoding/utils/custom_rich_text.dart';
import 'package:ghl_callrecoding/utils/custom_text_field.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Future<void> reportAlertDialog(BuildContext context, int leadId) {
  final ReportController reportController = Get.find<ReportController>();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Report Section'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              customRichText(text: "Report"),
              SizedBox(height: 5),
              Container(
                height: 90,
                child: CustomTextField(
                  controller: reportController.reportCon,
                  hintText: "Enter Report",
                  maxLines: 3,
                  onChange: (String value) {
                    reportController.isDisable();
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              width: 80,
              padding: EdgeInsets.all(10),
              child: Center(
                child: CustomText(
                  text: "Cancel",
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
            onTap: () {
              reportController.onTapCancel(context);
            },
          ),
          Obx(
            () => customButton(
                text: "Save",
                color: Colors.red,
                isDisable: reportController.disable.value,
                onTap: () {
                  reportController.onTapSave(context, leadId);
                }),
          ),
        ],
      );
    },
  );
}
