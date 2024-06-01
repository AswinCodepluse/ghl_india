import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget whatsappContainer({
  required double screenWidth,
  required String icon,
  required String text,
  required int count,
  Color? color,
  Color? iconColor,
}) {
  return Container(
    padding: EdgeInsets.all(screenWidth / 24),
    height: screenWidth / 7,
    decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(screenWidth / 36),
        border: Border.all(color: MyTheme.mainColor,width: 2)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: screenWidth / 14,
              width: screenWidth / 14,
              child: Image(
                image: AssetImage(icon),
                color: iconColor ?? Colors.black,
              ),
            ),
            SizedBox(
              width: screenWidth / 30,
            ),
            FittedBox(
              child: CustomText(
                text: text,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth / 20,
                color: iconColor ?? Colors.black,
              ),
            ),
          ],
        ),
        FittedBox(
          child: CustomText(
            text: count.toString(),
            fontSize: screenWidth / 14,
            color: iconColor ?? Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
