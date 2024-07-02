import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget textCard({required String text}) {
  return Container(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomText(
        text: text,
        maxLines: 10000,
      ),
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.0),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(-1, -1),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 9,
            blurRadius: 9,
            offset: Offset(5, 5),
          ),
        ]),
  );
}
