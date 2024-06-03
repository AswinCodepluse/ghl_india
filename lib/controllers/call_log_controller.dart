import 'dart:async';
import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
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
  String? firstCallStartTime;
  bool contain = false;

  RxBool loadingState = false.obs;
  StreamSubscription? _subscription;

  CallLogRepository callLogRepository = CallLogRepository();
  FileController fileController = Get.find<FileController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCallLogFromPhone();
  }

  void fetchCallLogFromPhone({Duration interval = const Duration(seconds: 5)}) {
    _subscription = Stream.periodic(interval).listen((_) async {
      await fetchCallLogs();
    });
  }

  Future<void> fetchCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.query(number: phoneNumber);
    callLogsList.assignAll(entries);
    print('callLogsList  $callLogsList');
    print('getCallLogsList  $getCallLogsList');
    if (callLogsList.isNotEmpty && getCallLogsList.isNotEmpty) {
      fileController.findRecordedFiles();
      String getFirstCallStartTime = getCallLogsList.first.startTime!;
      firstCallStartTime = formatTimestamp(callLogsList.first.timestamp!);
      print('firstCallStartTime $firstCallStartTime');
      print('getFirstCallStartTime $getFirstCallStartTime');
      // getCallLogsList.forEach((element) {
      //   if (element.startTime == firstCallStartTime) {
      //     contain = true;
      //   }
      // });
      // print('contain   ${contain}');
      // if (contain == false) {
      //   print("Call log if************************************");
      //   postCallLog();
      // }
      if (firstCallStartTime == getFirstCallStartTime) {
        print("Call log if************************************");
        return;
      } else {
        print("Call log else************************************");
        postCallLog();
      }
    } else if (callLogsList.isNotEmpty && getCallLogsList.isEmpty) {
      firstCallStartTime = formatTimestamp(callLogsList.first.timestamp!);
      print("2nd elseif-=========================================");
      postCallLog();
    }
  }

  postCallLog() async {
    List<String> dateTimeComponents =
        firstCallStartTime!.split(RegExp(r'[: \-]'));
    String joinedString = dateTimeComponents.join('');
    String userId = await SharedPreference().getUserId();
    DateTime findCallEndTime =
        DateTime.fromMillisecondsSinceEpoch(callLogsList.first.timestamp!);
    String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(findCallEndTime);
    String formattedDuration = formatDuration(callLogsList.first.duration!);
    String endTime = callEndTime(startTime: time, duration: formattedDuration);
    String callType = callTypeToString(callLogsList.first.callType!);
    String duration = "${callLogsList.first.duration}";
    File callRecordingFile = File("");
    if (fileController.filePathsWithPhoneNumber.isNotEmpty) {
      if (fileController.filePathsWithPhoneNumber.last.contains(phoneNumber) &&
          fileController.filePathsWithPhoneNumber.last.contains(joinedString)) {
        callRecordingFile = File(fileController.filePathsWithPhoneNumber.first);
      }
    }
    callLogRepository.postCallLog(
        leadId: leadId!,
        userId: userId,
        startTime: firstCallStartTime!,
        endTime: endTime,
        duration: duration,
        type: callType,
        callRecordingFile: callRecordingFile);
    await getCallLog();
  }

  Future<void> getCallLog() async {
    loadingState.value = true;
    getCallLogsList.clear();
    GetCallLogModel response = await callLogRepository.getCallLog(leadId!);
    print('response   ======= ${response.data}');
    getCallLogsList.addAll(response.data!);
    loadingState.value = false;
  }

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

  @override
  void onClose() {
    // TODO: implement onClose

    _subscription?.cancel();
    super.onClose();
  }
}
