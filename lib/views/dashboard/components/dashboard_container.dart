import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget dashboardContainer(
    {required double screenWidth,
      required String text,
      required int count,
      required String icon}) {
  return Container(
    padding: EdgeInsets.all(screenWidth / 45),
    height: screenWidth / 4.5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenWidth / 14.4,
              width: screenWidth / 14,
              child: Image(
                image: AssetImage(icon),
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: screenWidth / 15,
            ),
            FittedBox(
              child: CustomText(
                text: count.toString(),
                fontSize: screenWidth / 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        FittedBox(
          child: CustomText(
            text: text,
            fontWeight: FontWeight.w700,
            fontSize: screenWidth / 20,
            color: Colors.white,
          ),
        ),
      ],
    ),
    decoration: BoxDecoration(
      color: MyTheme.mainColor,
      borderRadius: BorderRadius.circular(screenWidth / 36),
    ),
  );
}