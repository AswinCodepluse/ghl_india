import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget subTitleRow(
    {required String firstSubTitle,
    required String secondSubTitle,
    required IconData firstIcon,
    required IconData secondIcon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 155,
          child: Row(
            children: [
              SizedBox(
                height: 25,
                width: 25,
                child: Icon(
                  firstIcon,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: CustomText(
                  text: firstSubTitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 15,
        ),
        SizedBox(
          width: 120,
          child: Row(
            children: [
              SizedBox(
                height: 25,
                width: 25,
                child: Icon(
                  secondIcon,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: CustomText(
                  text: secondSubTitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
