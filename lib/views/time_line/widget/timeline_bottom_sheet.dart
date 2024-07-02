import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/time_line_controller.dart';
import 'package:ghl_callrecoding/models/time_line_model.dart';



Future<void> timelineBottomSheet(BuildContext context, Data data) {
  TimeLineController timeLineController = Get.find<TimeLineController>();
  return showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
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
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Slider(
                  onChanged: timeLineController.onChange,
                  value: timeLineController.position.value == Duration.zero
                      ? 0.0
                      : timeLineController.position.value.inSeconds.toDouble(),
                  activeColor: Colors.purple,
                  min: 0.0,
                  max: timeLineController.duration?.inSeconds.toDouble() ?? 0.0,
                ),
              ),
              Obx(
                () => Text(
                  '${timeLineController.positionText} / ${timeLineController.durationText}',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (timeLineController.playerState.value ==
                      PlayerState.playing) {
                    timeLineController.pause();
                  } else if (timeLineController.playerState.value ==
                      PlayerState.stopped) {
                    timeLineController.play(data.voiceRecord!);
                  } else {
                    timeLineController.play(data.voiceRecord!);
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
              ),
            ],
          ),
        );
      });
}
