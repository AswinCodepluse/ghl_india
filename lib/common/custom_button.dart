import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
        required this.buttonText,
        required this.onTap,
        required this.disable});

  final String buttonText;
  final void Function() onTap;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disable ? null : onTap,
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
            color: disable ? Colors.grey.shade400 : Colors.red,
            borderRadius: BorderRadius.circular(15.0)),
        child: Center(
            child: CustomText(
              text: buttonText,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            )),
      ),
    );
  }
}