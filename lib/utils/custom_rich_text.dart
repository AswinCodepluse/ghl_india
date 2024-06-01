import 'package:flutter/material.dart';

Widget customRichText({required String text}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: text,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        TextSpan(
          text: " *",
          style: TextStyle(color: Colors.red, fontSize: 24),
        ),
      ],
    ),
  );
}