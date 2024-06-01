import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget roundContainer(
    {required int count,
    // String? color,
    required double screenWidth,
    required String text,
    required void Function() onTap}) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: screenWidth / 5.2,
          width: screenWidth / 5.2,
          child: Center(
            child: FittedBox(
              child: Padding(
                padding: EdgeInsets.all(screenWidth / 45),
                child: CustomText(
                  text: count.toString(),
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth / 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          decoration:
              BoxDecoration(color: MyTheme.mainColor, shape: BoxShape.circle),
        ),
      ),
      SizedBox(
        height: 8,
      ),
      SizedBox(
        width: 110,
        child: Center(
          child: FittedBox(
            child: CustomText(
              text: text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}
