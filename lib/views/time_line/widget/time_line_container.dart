import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/models/time_line_model.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget timeLineContainer(Data data) {
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
                  image: NetworkImage(data.file!), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 118,
              child: CustomText(
                text: data.user ?? '',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 118,
              child: CustomText(
                text: "Notes : ${data.notes}",
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 120,
              child: CustomText(
                text: data.createdAt ?? '',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            )
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 115,
              child: CustomText(
                text: "Status : ${data.newStatus}",
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 115,
              child: CustomText(
                text: "Next Followup Date",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 115,
              child: CustomText(
                text: data.nextFollowUpDate ?? '',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        )
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
