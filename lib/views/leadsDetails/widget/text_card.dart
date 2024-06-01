import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget textCard({required String text}) {
  LeadsController leadsController = Get.find<LeadsController>();
  return Container(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomText(
        text: text,
        color: Colors.grey,
        maxLines: 10,
      ),
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: leadsController.shadow),
  );
}
