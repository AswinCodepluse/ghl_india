import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/repositories/call_log_repository.dart';
import 'package:intl/intl.dart';

class CallLogFun {
  List<CallLogEntry> allCallLogsList = <CallLogEntry>[];
  bool result = true;
  FileController fileController = Get.put(FileController());

  Future<void> fetchAllCallLogs() async {
    print("Fetching All Call log functions");
    Iterable<CallLogEntry> entries = await CallLog.query();
    allCallLogsList.addAll(entries);
    for (int i = 0; i < allCallLogsList.length; i++) {
      String userId = await SharedPreference().getUserId();
      DateTime findCallEndTime =
          DateTime.fromMillisecondsSinceEpoch(allCallLogsList[i].timestamp!);
      String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(findCallEndTime);
      String formattedDuration = formatDuration(allCallLogsList[i].duration!);
      String endTime =
          callEndTime(startTime: time, duration: formattedDuration);
      String callType = callTypeToString(allCallLogsList[i].callType!);
      String duration = "${allCallLogsList[i].duration}";
      String number = allCallLogsList[i].number!;
      String formattedStartTime =
          formatTimestamp(allCallLogsList[i].timestamp!);
      File callRecordingFile = await fetchRecordingFile(
          fromCallStartTime: formattedStartTime, fromCallEndTime: endTime);
      if (result == true) {
        print('===============fetchAllCallLogs==================');
        print("userId  $userId");
        print("endTime  $endTime");
        print("duration  $duration");
        print("callType  $callType");
        print("startTime  $formattedStartTime");
        print("number  $number");
        print("callRecordingFile  $callRecordingFile");
        print('=================fetchAllCallLogs================');
        await fileController.findRecordedFiles();
        await postCallLogForAdmin(
            userId: userId,
            endTime: endTime,
            duration: duration,
            callType: callType,
            startTime: formattedStartTime,
            number: number,
            callRecordingFile: callRecordingFile);
      } else {
        break;
      }
    }
  }

  Future<void> postCallLogForAdmin({
    required String userId,
    required String startTime,
    required String number,
    required String endTime,
    required String duration,
    required String callType,
    required File callRecordingFile,
  }) async {
    var response = await CallLogRepository().postCallLogForAdmin(
      phoneNumber: number,
      userId: userId,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      type: callType,
      callRecordingFile: callRecordingFile,
    );
    if (response.result == false) {
      result = false;
    } else {
      result = true;
    }
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

  File fetchRecordingFile(
      {required String fromCallStartTime, required String fromCallEndTime}) {
    File callRecordingFile = File("");
    if (fileController.callRecordingFilesList.isNotEmpty) {
      DateTime callStartTime = DateTime.parse(fromCallStartTime);
      DateTime callEndTime = DateTime.parse(fromCallEndTime);

      for (int i = 0; i < fileController.callRecordingFilesList.length; i++) {
        String filePath = fileController.callRecordingFilesList[i].path;
        String fileName = filePath.split('/').last;
        RegExp regExp = RegExp(r"_(\d{6})_(\d{6})\.m4a");
        Match? match = regExp.firstMatch(fileName);
        if (match != null) {
          String datePart = match.group(1)!;
          String timePart = match.group(2)!;
          String dateTimeString =
              "20${datePart.substring(0, 2)}-${datePart.substring(2, 4)}-${datePart.substring(4, 6)} " +
                  "${timePart.substring(0, 2)}:${timePart.substring(2, 4)}:${timePart.substring(4, 6)}";
          DateTime fileTimestamp = DateTime.parse(dateTimeString);
          if (fileTimestamp.isAfter(callStartTime) &&
              fileTimestamp.isBefore(callEndTime)) {
            callRecordingFile = File(filePath);
            break;
          }
        }
      }
    }
    return callRecordingFile;
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
}
