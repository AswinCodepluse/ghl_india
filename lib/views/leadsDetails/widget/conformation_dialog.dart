import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';

AlertDialog conformationDialog(
    BuildContext context, LeadsController leadsController) {
  return AlertDialog(
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.only(
      left: 15,
      right: 15,
      top: 15,
    ),
    content: SizedBox(
      height: 57,
      width: 250,
      child: Obx(
        () => leadsController.loadingState.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : Center(
                child: Text(
                  leadsController.message.value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Obx(
          () => !leadsController.loadingState.value
              ? Text(
                  "OK",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )
              : Container(),
        ),
      ),
    ],
  );
}
