import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget titleRow({required String firstTitle, required String secondTitle}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 155,
          child: CustomText(
            text: firstTitle,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          width: 15,
        ),
        SizedBox(
          width: 120,
          child: CustomText(
            text: secondTitle,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        )
      ],
    ),
  );
}