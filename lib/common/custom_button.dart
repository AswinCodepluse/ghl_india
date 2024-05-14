
import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.buttonText, required this.onTap});

  final String buttonText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(15.0)),
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
