import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/time_line_controller.dart';
import 'package:ghl_callrecoding/models/time_line_model.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget timeLineContainer({required Data data, required void Function() onTap}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder(
                init: TimeLineController(),
                builder: (timeLineController) {
                  return data.callRecord == null
                      ? Container(
                          height: 208,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(data.file!),
                                fit: BoxFit.fill),
                          ),
                        )
                      : Container(
                          height: 208,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: onTap,
                                child: Icon(
                                  Icons.play_circle_filled_rounded,
                                  color: Colors.purple,
                                  size: 90,
                                ),
                              ),
                            ],
                          ),
                        );
                }),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: data.user ?? '',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Status : ",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        text: "${data.newStatus}",
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomText(text: "Notes"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: CustomText(
                  text: "${data.notes}",
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  maxLines: 3,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Uploaded on',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    text: 'Next Followup Date',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: data.createdAt ?? '',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: data.nextFollowUpDate ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        text: data.nextFollowUpTime ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // margin: EdgeInsets.all(5),
      // padding: EdgeInsets.all(5),
      // height: 410,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15),
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.shade600,
      //         spreadRadius: 1,
      //         blurRadius: 2,
      //       )
      //     ]
      //     ),
    ),
  );
}
