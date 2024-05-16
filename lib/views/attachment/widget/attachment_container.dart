import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/models/attachment_model.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget attachmentContainer(AttachmentData data) {
  return Container(
    child: Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/image/png_image.png"), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(
          width: 8,
        ),
        CustomText(
          text: data.name ?? '',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ],
    ),
    margin: EdgeInsets.all(5),
    height: 90,
    decoration: BoxDecoration(
        border: Border(
      bottom: BorderSide(
        color: Colors.grey,
        width: 0.5,
      ),
    )),
  );
}
