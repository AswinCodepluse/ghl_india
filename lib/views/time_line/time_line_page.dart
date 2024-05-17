import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/time_line_controller.dart';
import 'package:ghl_callrecoding/models/time_line_model.dart';
import 'package:ghl_callrecoding/views/time_line/widget/time_line_container.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class TimeLinePage extends StatefulWidget {
  TimeLinePage({super.key});

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  final timeLineController = Get.put(TimeLineController());

  @override
  void initState() {
    // TODO: implement initState
    timeLineController.fetchTimeLine(timeLineController.leadId.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Activity Timeline"),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: timeLineController.activeTimeLineList.length,
                    itemBuilder: (context, index) {
                      final data = timeLineController.activeTimeLineList[index];
                      return timeLineContainer(data);
                    }), // FutureBuilder(
                //   future: timeLineController.fetchTimeLine(4),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Center(
                //           child:
                //               CircularProgressIndicator()); // Show a loading indicator
                //     } else if (snapshot.hasError) {
                //       return Text('Error: ${snapshot.error}');
                //     } else {
                //       return Expanded(
                //         child: ListView.builder(
                //             itemCount: timeLineController.activeTimeLineList.length,
                //             itemBuilder: (context, index) {
                //               final data =
                //                   timeLineController.activeTimeLineList[index];
                //               return timeLineContainer(data);
                //             }),
                //       );
                //     }
                //   },
                // ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
