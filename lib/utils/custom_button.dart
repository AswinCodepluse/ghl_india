import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget customButton({
  required String text,
  required Color color,
  required void Function() onTap,
  bool? isDisable,
}) {
  return GestureDetector(
    child: Container(
      width: 80,
      padding: EdgeInsets.all(10),
      child: Center(
        child: CustomText(
          text: text,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
          color: isDisable == true ? color : Colors.grey,
          borderRadius: BorderRadius.circular(10)),
    ),
    onTap: isDisable == true ? onTap : null,
  );
}