import 'dart:async';
import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/get_call_log_model.dart';
import 'package:ghl_callrecoding/repositories/call_log_repository.dart';
import 'package:intl/intl.dart';

class CallLogController extends GetxController {
  // CallLogController({required this.phoneNumber, this.leadId});

  RxList<CallLogEntry> callLogsList = <CallLogEntry>[].obs;
  RxList<GetCallLogData> getCallLogsList = <GetCallLogData>[].obs;

  // final String phoneNumber;
  // final String? leadId;
  RxList<CallLogEntry> allCallLogsList = <CallLogEntry>[].obs;
  bool result = true;

  // String? firstCallStartTime;
  bool callLogResult = true;

  RxBool loadingState = false.obs;
  StreamSubscription? _subscription;

  CallLogRepository callLogRepository = CallLogRepository();
  FileController fileController = Get.put(FileController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // fetchCallLogs();
    // fetchAllCallLogs();
    Future.delayed(Duration(seconds: 5), () {
      postCallRecordingFile();
    });
  }

  // void fetchCallLogFromPhone(
  //     {Duration interval = const Duration(seconds: 15)}) {
  //   _subscription = Stream.periodic(interval).listen((_) async {
  //     await fetchCallLogs();
  //   });
  // }

  Future<void> postCallRecordingFile() async {
    String userId = await SharedPreference().getUserId();
    if (fileController.callRecordingBox.isNotEmpty) {
      fileController.callRecordingBox.values.forEach((element) async {
        DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        String timeStamp = formatter.format(element.timestamp!);
        print('element.timestamp ${timeStamp}');
        await callLogRepository.postCallRecordingFile(
            userId: userId,
            dateTime: '${timeStamp}',
            callRecordingFile: File(element.filePath!));
      });
      await fileController.callRecordingBox.clear();
    }
  }

  Future<void> fetchCallLogs(
      {required String phoneNumber, required String leadId}) async {
    print('yes entered -----------------------------');
    loadingState.value = true;
    Iterable<CallLogEntry> entries = await CallLog.query(number: phoneNumber);
    callLogsList.assignAll(entries);
    // callLogResult = true;

    if (callLogsList.isEmpty) {
      getCallLog(leadId: leadId);
    }
    print('callLogsList  $callLogsList');
    print('getCallLogsList  $getCallLogsList');
    if (callLogsList.isNotEmpty && getCallLogsList.isNotEmpty) {
      // String getFirstCallStartTime = getCallLogsList.first.startTime!;
      // firstCallStartTime = formatTimestamp(callLogsList.first.timestamp!);
      String callLogPhoneNumber =
          callLogsList.first.number!.replaceFirst("+91", "");
      // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      // DateTime parsedFirstCallStartTime = dateFormat.parse(firstCallStartTime!);
      // DateTime parsedGetFirstCallStartTime =
      //     dateFormat.parse(getFirstCallStartTime);

      for (int i = 0; i < callLogsList.length; i++) {
        // String modifiedCallStartTime = convertDateTimeFormat(callStartTime);
        // print('modifiedCallStartTime $modifiedCallStartTime');
        print(
            "firstCallStartTime=======================================///////////// ${formatTimestamp(callLogsList[i].timestamp!)}");
        if (callLogResult == true && callLogPhoneNumber == phoneNumber) {
          print(' =======================================postCallLog');
          await postCallLog(callLog: callLogsList[i], leadId: leadId);
        } else {
          print('break =======================================/////////////');
          break;
        }

        // var callStartTime = formatTimestamp(callLogsList[i].timestamp!);
        // DateTime parsedCallStartTime = dateFormat.parse(callStartTime);
        // if (parsedCallStartTime.isAfter(parsedGetFirstCallStartTime) &&
        //     callLagPhoneNumber == phoneNumber) {
        //   print("Call log if************************************${i}");
        //   await postCallLog();
        // } else {
        //   print('break ======================${i}');
        //   break;
        // }
      }
      // if (parsedFirstCallStartTime.isAfter(parsedGetFirstCallStartTime) &&
      //     firstCallPhone == phoneNumber) {
      //   print("Call log if************************************");
      //   postCallLog();
      // }
    } else if (callLogsList.isNotEmpty && getCallLogsList.isEmpty) {
      print("2nd elseif-=========================================");
      await postCallLog(callLog: callLogsList.first, leadId: leadId);
    }
    loadingState.value = false;
  }

  Future<void> postCallLog(
      {required CallLogEntry callLog, required String leadId}) async {
    await fileController.findRecordedFiles();
    // String modifiedCallStartTime = convertDateTimeFormat(callStartTime);
    var callStartTime = formatTimestamp(callLog.timestamp!);
    String userId = await SharedPreference().getUserId();
    DateTime findCallEndTime =
        DateTime.fromMillisecondsSinceEpoch(callLog.timestamp!);
    String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(findCallEndTime);
    String formattedDuration = formatDuration(callLog.duration!);
    String endTime = callEndTime(startTime: time, duration: formattedDuration);
    File callRecordingFile = await fetchRecordingFile(
        fromCallStartTime: callStartTime, fromCallEndTime: endTime);
    String callType = callTypeToString(callLog.callType!);
    String duration = "${callLog.duration}";

    // fetchRecordingFile();
    // if (fileController.callRecordingFilesList.isNotEmpty) {
    //   for (int i = 0; i < fileController.callRecordingFilesList.length; i++) {
    //     if (fileController.callRecordingFilesList[i].path
    //         .contains(modifiedCallStartTime)) {
    //       callRecordingFile =
    //           File(fileController.callRecordingFilesList[i].path);
    //       break;
    //     }
    //   }
    // }
    print('===============postCallLog==================');
    print("userId  $userId");
    print("endTime  $endTime");
    print("duration  $duration");
    print("callType  $callType");
    print("startTime  $callStartTime");
    print("callRecordingFile  $callRecordingFile");
    print('=================postCallLog================');
    var response = await callLogRepository.postCallLog(
        leadId: leadId,
        userId: userId,
        startTime: callStartTime,
        endTime: endTime,
        duration: duration,
        type: callType,
        callRecordingFile: callRecordingFile);
    if (response.result == false) {
      callLogResult = false;
    } else {
      callLogResult = true;
    }
    await getCallLog(leadId: leadId);
  }

  Future<void> getCallLog({required String leadId}) async {
    print('yes entered getCallLog ============');

    getCallLogsList.clear();
    GetCallLogModel response = await callLogRepository.getCallLog(leadId);
    getCallLogsList.addAll(response.data!);
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

  String convertDateTimeFormat(String dateTime) {
    List<String> dateTimeComponents = dateTime.split(RegExp(r'[: \-]'));

    String year = dateTimeComponents[0].substring(2);
    String month = dateTimeComponents[1];
    String day = dateTimeComponents[2];
    String hour = dateTimeComponents[3];
    String minute = dateTimeComponents[4];
    String second = dateTimeComponents[5];

    String modifiedDateTime = '$year$month$day\_$hour$minute$second';

    return modifiedDateTime;
  }

  Future<void> fetchAllCallLogs() async {
    print("Fetching All Call log functions");
    Iterable<CallLogEntry> entries = await CallLog.query();
    allCallLogsList.assignAll(entries);
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
    var response = await callLogRepository.postCallLogForAdmin(
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

  @override
  void onClose() {
    // TODO: implement onClose

    _subscription?.cancel();
    super.onClose();
  }
}
