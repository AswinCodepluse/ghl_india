import 'dart:async';

import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CallLogController extends GetxController {
  CallLogController({required this.phoneNumber});

  String leadPhoneNumber = "";
  RxList<CallLogEntry> callLogsList = <CallLogEntry>[].obs;
  final String phoneNumber;
  Timer? _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startListening();
    // fetchCallLogs();
  }

  void startListening({Duration interval = const Duration(seconds: 5)}) {
    _timer = Timer.periodic(interval, (timer) async {
      Iterable<CallLogEntry> entries = await CallLog.query(number: phoneNumber);
      callLogsList.assignAll(entries);
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose

    _timer?.cancel();
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

  String callTypeToString(CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return "Incoming";
      case CallType.wifiIncoming:
        return "Incoming";
      case CallType.outgoing:
        return "Outgoing";
      case CallType.wifiOutgoing:
        return "Outgoing";
      case CallType.missed:
        return "Missed";
      case CallType.rejected:
        return "Rejected";
      default:
        return "unknown";
    }
  }

  String callTypeIcon(CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return "assets/image/call_incoming_icon.png";
      case CallType.wifiIncoming:
        return "assets/image/call_incoming_icon.png";
      case CallType.outgoing:
        return "assets/image/call_outgoing_icon.png";
      case CallType.wifiOutgoing:
        return "assets/image/call_outgoing_icon.png";
      case CallType.missed:
        return "assets/image/call_missed_icon.png";
      case CallType.rejected:
        return "assets/image/call_rejected_icon.png";
      default:
        return "unknown";
    }
  }
}
