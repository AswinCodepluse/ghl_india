import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/call_log_controller.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class CallLogScreen extends StatefulWidget {
  CallLogScreen({super.key, required this.leadPhoneNumber});

  final String leadPhoneNumber;

  @override
  State<CallLogScreen> createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  final CallLogController callLogController = Get.put(CallLogController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callLogController.fetchCallLogs(widget.leadPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Call Logs"),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Obx(() {
              return Expanded(
                child: callLogController.callLogsList.isEmpty
                    ? Center(
                        child: CustomText(
                            text: "No Call Log History For This Lead"))
                    : ListView.builder(
                        itemCount: callLogController.callLogsList.length,
                        itemBuilder: (context, index) {
                          final data = callLogController.callLogsList[index];
                          return callLogContainer(data);
                        }),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget callLogContainer(CallLogEntry data) {
    String dateTime = callLogController.formatTimestamp(data.timestamp!);
    String duration = callLogController.formatDuration(data.duration!);
    String callTypes = callLogController.callTypeToString(data.callType!);
    String icon = callLogController.callTypeIcon(data.callType!);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 5,
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage(icon), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: data.number ?? '',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                text: dateTime,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              callTypes != "Rejected" && callTypes != "Missed"
                  ? CustomText(
                      text: duration,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )
                  : Container(),
              CustomText(
                text: callTypes,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: callTypes == "Rejected" || callTypes == "Missed"
                    ? Colors.red
                    : Colors.grey,
              ),
            ],
          )
        ],
      ),
      margin: EdgeInsets.all(5),
      height: 70,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      )),
    );
  }
}
