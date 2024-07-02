import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/time_line_controller.dart';
import 'package:ghl_callrecoding/models/time_line_model.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:photo_view/photo_view.dart';

Widget timeLineContainer(
    {required Data data,
    required void Function() onTap,
    required BuildContext context}) {
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
                  return data.voiceRecord == null
                      ? GestureDetector(
                          child: Container(
                            height: 208,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(data.file!),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          onTap: () {
                            openPhotoDialog(context, data.file!);
                          },
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
              child: CustomText(
                text: data.user ?? '',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                CustomText(
                  text: "Status : ",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: "${data.oldStatus}",
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CustomText(
                    text: "to",
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                CustomText(
                  text: "${data.newStatus}",
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0,top: 5),
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
            CustomText(
                text: "Notes", fontSize: 16, fontWeight: FontWeight.bold),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: CustomText(
                  text: "${data.notes}",
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  maxLines: 10000,
                ),
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

openPhotoDialog(BuildContext context, path) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
              child: Stack(
            children: [
              PhotoView(
                enableRotation: true,
                heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                imageProvider: NetworkImage(path),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: ShapeDecoration(
                    color: MyTheme.medium_grey_50,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: const Icon(Icons.clear, color: MyTheme.white),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ),
            ],
          )),
        );
      },
    );
