import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/time_line_controller.dart';

import '../../../models/time_line_model.dart';

Future<void> timelineBottomSheet(BuildContext context, Data data) {
  TimeLineController timeLineController = Get.find<TimeLineController>();
  return showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        timeLineController.stop();
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                          )))),
              Obx(
                () => Slider(
                  onChanged: timeLineController.onChange,
                  value: timeLineController.position.value == Duration.zero
                      ? 0.0
                      : timeLineController.position.value.inSeconds.toDouble(),
                  activeColor: Colors.purple,
                  min: 0.0,
                  max: 12.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (timeLineController.playerState.value ==
                      PlayerState.playing) {
                    timeLineController.pause();
                  } else {
                    timeLineController.play(data.callRecord!);
                  }
                },
                child: Obx(
                  () => timeLineController.playerState.value ==
                          PlayerState.playing
                      ? Icon(
                          Icons.pause_circle_filled_rounded,
                          color: Colors.purple,
                          size: 90,
                        )
                      : Icon(
                          Icons.play_circle_filled_rounded,
                          color: Colors.purple,
                          size: 90,
                        ),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          )),
        );
      });
}
