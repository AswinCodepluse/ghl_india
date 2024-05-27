import 'dart:async';
import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/get_call_log_model.dart';
import 'package:ghl_callrecoding/repositories/call_log_repository.dart';
import 'package:intl/intl.dart';

class CallLogController extends GetxController {
  CallLogController({required this.phoneNumber, this.leadId});

  String leadPhoneNumber = "";
  RxList<CallLogEntry> callLogsList = <CallLogEntry>[].obs;
  RxList<GetCallLogData> getCallLogsList = <GetCallLogData>[].obs;
  final String phoneNumber;
  final String? leadId;

  RxBool loadingState = false.obs;
  StreamSubscription? _subscription;

  CallLogRepository callLogRepository = CallLogRepository();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startListening();
    // fetchCallLogs();
  }

  void startListening({Duration interval = const Duration(seconds: 5)}) {
    _subscription = Stream.periodic(interval).listen((_) async {
      await fetchCallLogs();
    });
  }

  Future<void> fetchCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.query(number: phoneNumber);
    callLogsList.assignAll(entries);
    if (callLogsList.isNotEmpty && getCallLogsList.isNotEmpty) {
      String firstCallStartTime =
          formatTimestamp(callLogsList.first.timestamp!);
      String getFirstCallStartTime = getCallLogsList.first.startTime!;
      if (firstCallStartTime == getFirstCallStartTime) {
        print("+============if==============");
        return;
      } else {
        print("===============else==========");
        String userId = await SharedPreference().getUserId();
        DateTime findCallEndTime =
            DateTime.fromMillisecondsSinceEpoch(callLogsList.first.timestamp!);
        String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(findCallEndTime);
        String formattedDuration = formatDuration(callLogsList.first.duration!);
        String endTime =
            callEndTime(startTime: time, duration: formattedDuration);
        String callType = callTypeToString(callLogsList.first.callType!);
        String duration = "${callLogsList.first.duration}";
        callLogRepository.postCallLog(
            leadId: leadId!,
            userId: userId,
            startTime: firstCallStartTime,
            endTime: endTime,
            duration: duration,
            type: callType,
            callRecordingFile: File(""));
        await getCallLog();
      }
    }
  }

  Future<void> getCallLog() async {
    loadingState.value = true;
    getCallLogsList.clear();
    GetCallLogModel response = await callLogRepository.getCallLog(leadId!);
    getCallLogsList.addAll(response.data!);
    loadingState.value = false;
  }

  @override
  void onClose() {
    // TODO: implement onClose

    _subscription?.cancel();
    super.onClose();
  }

  // Future<void> fetchCallLogs(String phoneNumber) async {
  //   var status = await Permission.phone.status;
  //
  //   if (!status.isGranted) {
  //     if (await Permission.phone.request().isGranted) {
  //       retrieveCallLogs(phoneNumber);
  //     }
  //   } else {
  //     retrieveCallLogs(phoneNumber);
  //   }
  // }

  // Future<void> retrieveCallLogs(String phoneNumber) async {
  //   Iterable<CallLogEntry> queryEntries = await CallLog.query(
  //     number: phoneNumber,
  //   );

  //   callLogsList.addAll(queryEntries);
  //
  //   int? timestamp = queryEntries.first.timestamp;
  //   int? duration = queryEntries.first.duration;
  //   formatTimestamp(timestamp!);
  //   formatDuration(duration!);
  //
  //   update();
  // }

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int secs = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return formattedDate;
  }

  // String callEndTime({required String startTime,required String duration}) {
  //
  //   DateTime time1DateTime = DateFormat('HH:mm:ss').parse(startTime);
  //
  //   return "aswin";
  // }

  String callEndTime({required String startTime, required String duration}) {
    DateTime time1DateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(startTime);
    List<String> durationParts = duration.split(':');
    Duration durationObj = Duration(
      hours: int.parse(durationParts[0]),
      minutes: int.parse(durationParts[1]),
      seconds: int.parse(durationParts[2]),
    );
    DateTime endTimeDateTime = time1DateTime.add(durationObj);
    String endTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(endTimeDateTime);

    return endTime;
  }

  String callTypeToString(CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return "incoming";
      case CallType.wifiIncoming:
        return "incoming";
      case CallType.outgoing:
        return "outgoing";
      case CallType.wifiOutgoing:
        return "outgoing";
      case CallType.missed:
        return "missed";
      case CallType.rejected:
        return "rejected";
      default:
        return "unknown";
    }
  }

  String callTypeIcon(String callType) {
    switch (callType) {
      case "incoming":
        return "assets/image/call_incoming_icon.png";
      case "outgoing":
        return "assets/image/call_outgoing_icon.png";
      case "missed":
        return "assets/image/call_missed_icon.png";
      case "rejected":
        return "assets/image/call_rejected_icon.png";
      default:
        return "unknown";
    }
  }

// String callTypeIcon(CallType callType) {
//   switch (callType) {
//     case CallType.incoming:
//       return "assets/image/call_incoming_icon.png";
//     case CallType.wifiIncoming:
//       return "assets/image/call_incoming_icon.png";
//     case CallType.outgoing:
//       return "assets/image/call_outgoing_icon.png";
//     case CallType.wifiOutgoing:
//       return "assets/image/call_outgoing_icon.png";
//     case CallType.missed:
//       return "assets/image/call_missed_icon.png";
//     case CallType.rejected:
//       return "assets/image/call_rejected_icon.png";
//     default:
//       return "unknown";
//   }
// }
}
