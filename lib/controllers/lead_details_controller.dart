import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/models/lead_datas_create_model.dart';
import 'package:ghl_callrecoding/models/lead_details_model.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_share/whatsapp_share.dart';

class LeadsController extends GetxController {
  var isLeads = false.obs;
  RxString fileName = ''.obs;
  var selectedLeadIds = 0.obs;
  var selectedLeadNames = ''.obs;
  TextEditingController fileCon = TextEditingController();
  TextEditingController statusCon = TextEditingController();
  TextEditingController followupNotesCon = TextEditingController();
  TextEditingController datePickedCon = TextEditingController();
  TextEditingController dateTimeCon = TextEditingController();
  TextEditingController timeCon = TextEditingController();
  var leadStatusList = <Data>[].obs;
  RxList<String> leadStatusNameList = <String>[].obs;
  RxString selectedLeadStatus = ''.obs;
  RxString message = ''.obs;
  File lastCallRecording = File("");
  RxString selectedLeadPhoneNumber = ''.obs;
  File? files;
  bool isSubmitted = false;
  String hours = '';
  String minutes = '';
  RxBool loadingState = false.obs;

  // var leadDetailsData = Rx<LeadDetails?>(LeadDetails);
  Rx<LeadDetails> leadDetailsData = LeadDetails().obs;

  File callFiles = File("");
  var setDisable = true.obs;
  TextEditingController callRecordingFileCon = TextEditingController();
  TextEditingController pathSetupCon = TextEditingController();
  RxString callFileName = ''.obs;
  String token = '';
  String postTime = '';
  var remindDate = "";
  FileController fileController = Get.put(FileController());

  @override
  void onInit() {
    // TODO: implement onInit
    fetchAll();
    fetchLeadStatus();

    fetchLastCallRecordingFile();
    super.onInit();
  }

  @override
  void onClose() {
    clearAll();
    // TODO: implement onClose
    super.onClose();
  }

  List<BoxShadow> shadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.0),
      spreadRadius: 0,
      blurRadius: 0,
      offset: Offset(-1, -1),
    ),
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 9,
      blurRadius: 9,
      offset: Offset(5, 5),
    ),
  ];

  isDisable() {
    if (
        // (fileCon.text.isEmpty || fileCon.text == '') ||
        //     (callRecordingFileCon.text.isEmpty ||
        //         callRecordingFileCon.text == '')
        //     || (datePickedCon.text.isEmpty ||
        //     datePickedCon.text == '') ||
        (followupNotesCon.text.isEmpty || followupNotesCon.text == '')) {
      setDisable.value = true;
    } else {
      setDisable.value = false;
    }
  }

  Future<void> displayTimePicker(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final String formattedTime = picked.format(context);

      postTime = formatTimeOfDay(picked);
      controller.text = formattedTime;
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    hours = time.hour.toString().padLeft(2, '0');
    minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future displayDatePicker(BuildContext context, dateValue) async {
    DateTime date = DateTime(1900);
    FocusScope.of(context).requestFocus(FocusNode());
    date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)) as DateTime;
    if (date != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      dateValue.text = formatter.format(date);
      datePickedCon.text = formatter.format(date);
      remindDate = dateValue.text;
      // SharedPreference().setRemainderDate(remindDate);
      // FirebaseRepository().setNotification();
      update();
    }
  }

  Future dateTimePicker(BuildContext context) async {
    return DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2000, 1, 1),
        maxTime: DateTime(4000, 12, 31), onConfirm: (date) {
      String desiredFormat = "yyyy-MM-dd HH:mm";
      dateTimeCon.text = DateFormat(desiredFormat).format(date);
      update();
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  // setNotification() async {
  //   String dateString = datePickedCon.text;
  //   List<String> dateParts = dateString.split('-');
  //   // final pickedHours = time.hour.toString().padLeft(2, '0');
  //   // final pickedMinutes = time.minute.toString().padLeft(2, '0');
  //   int year = int.parse(dateParts[0]);
  //   int month = int.parse(dateParts[1]);
  //   int day = int.parse(dateParts[2]);
  //   int pickedHours = int.parse(hours);
  //   int pickedMinutes = int.parse(minutes);
  //   FirebaseRepository firebaseRepo = FirebaseRepository();
  //   await firebaseRepo.getToken().then((value) => token = value);
  //   final targetDateTime =
  //       DateTime(year, month, day, pickedHours, pickedMinutes);
  //   firebaseRepo.scheduleNotificationAtSpecificTime(targetDateTime, token);
  // }

  fetchAllLeadsDatas() async {
    isLeads.value = true;
    isLeads.value = false;
    update();
  }

  fetchAll() {
    fetchAllLeadsDatas();
  }

  clearAll() {
    fileCon.clear();
    followupNotesCon.clear();
    callRecordingFileCon.clear();
    datePickedCon.clear();
    dateTimeCon.clear();
    timeCon.clear();
  }

  onChanged(String? newValue) {
    selectedLeadStatus.value = newValue!;
    update();
  }

  Future<void> pickFile(String fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (fileType == "Call") {
      if (result != null) {
        callFiles = File(result.files.single.path!);
        callFileName.value = callFiles.path.split('/').last;
        callRecordingFileCon.text = callFiles.path.split('/').last;

        // if (!callFiles.path.contains(".mp3") &&
        //     !callFiles.path.contains(".amr") &&
        //     !callFiles.path.contains(".jpg") &&
        //     !callFiles.path.contains(".jpeg") &&
        //     !callFiles.path.contains(".m4a")) {
        //   String reNameFilePath = '';
        //   reNameFilePath += "${callFiles.path}.mp3";
        //   callFiles = await File(reNameFilePath).rename(reNameFilePath);
        //   callRecordingFileCon.text = callFiles.path.split('/').last;
        //   print(reNameFilePath);
        // }

        update();
      }
    } else {
      if (result != null) {
        files = File(result.files.single.path!);
        fileName.value = files!.path.split('/').last;
        fileCon.text = files!.path.split('/').last;

        update();
      }
    }
  }

  Future<LeadDatasCreate> createLead(
    int? leadId,
    int? userId,
    int? oldStatus,
    int status,
    String testNotes,
    String date,
    String time,
    File files,
    File callRecord,
    File voiceRecord,
  ) async {
    try {
      loadingState.value = true;
      LeadDatasCreate response = await Dashboard().postLeadData(
          leadId,
          userId,
          oldStatus,
          status,
          testNotes,
          date,
          time,
          files,
          callRecord,
          voiceRecord);
      message.value = response.message!;
      return response;
    } catch (e) {
      message.value = "Something Went Wrong";
      throw "$e";
    } finally {
      loadingState.value = false;
    }
  }

  fetchIndividualLeads(int id) async {
    leadDetailsData.value = await Dashboard().fetchOIndividualLeads(id);

    selectedLeadIds.value = leadDetailsData.value.statusInt!;
  }

  fetchLeadStatus() async {
    isLeads.value = true;
    var leadsResponse = await Dashboard().fetchLeadStatus();
    leadStatusList.addAll(leadsResponse);

    // Clear lists before adding to avoid duplicates
    leadStatusNameList.clear();

    for (int i = 0; i < leadStatusList.length; i++) {
      leadStatusNameList.add(leadStatusList[i].name!);
    }

    // Convert to a Set to remove duplicates
    Set<String> uniqueStatusNames = leadStatusNameList.toSet();
    leadStatusNameList.value = uniqueStatusNames.toList();
    isLeads.value = false;
    update();
  }

  openSMS({required String phoneNumber, required BuildContext context}) async {
    try {
      if (Platform.isAndroid) {
        String uri =
            'sms:$phoneNumber?body=${Uri.encodeComponent("Hello, I have a question about https://ghlindia.com/")}';
        await launchUrl(Uri.parse(uri));
      } else if (Platform.isIOS) {
        String uri =
            'sms:$phoneNumber&body=${Uri.encodeComponent("Hello, I have a question about https://ghlindia.com/")}';
        await launchUrl(Uri.parse(uri));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some error occurred. Please try again!'),
        ),
      );
    }
  }

  openWhatsApp(context, phoneNumber) async {
    var whatsapp = "$phoneNumber";

    var whatsappURl_android = "whatsapp://send?phone=" +
        whatsapp +
        "&text=Hello, I have a question about https://ghlindia.com/";
    var whatsappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatsappURL_ios)) {
        await launch(whatsappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed")));
      }
    }
  }

  fetchLastCallRecordingFile() async {
    if (fileController.filePathsWithPhoneNumber.isNotEmpty) {
      if (fileController.filePathsWithPhoneNumber.last
          .contains(selectedLeadPhoneNumber)) {
        callRecordingFileCon.text =
            fileController.filePathsWithPhoneNumber.last;
        lastCallRecording = File(fileController.filePathsWithPhoneNumber.last);
      }
    }
  }

  // Future<void> shareDocument(
  //     {required String phoneNumber, required String url}) async {
  //   final filePath = await downloadFile(url: url);
  //   if (filePath != null) {
  //     print('phoneNumber $phoneNumber');
  //     try {
  //       print('91$phoneNumber');
  //       await WhatsappShare.shareFile(
  //         phone: "91$phoneNumber",
  //         filePath: [filePath],
  //       );
  //       var whatsappUrl = "whatsapp://send?phone=91$phoneNumber";
  //       if (await canLaunch(whatsappUrl)) {
  //         await launch(whatsappUrl);
  //       } else {
  //         throw 'Could not launch WhatsApp';
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     print('Error creating document');
  //   }
  // }

  // Future<void> shareDocument(String url, String phoneNumber) async {
  //   if (url.isNotEmpty && phoneNumber.isNotEmpty) {
  //     try {
  //       final filePath = await downloadFile(url: url);
  //       await WhatsappShare.shareFile(
  //         phone: "91$phoneNumber",
  //         filePath: [filePath!],
  //       );
  //       Uri(
  //         scheme: 'https',
  //         host: 'api.whatsapp.com',
  //         path: 'send',
  //         queryParameters: {
  //           'phone': '91$phoneNumber',
  //         },
  //       );
  //       var whatsappUrl = "whatsapp://phone=$phoneNumber";
  //       if (await canLaunch(whatsappUrl.toString())) {
  //         await launch(whatsappUrl.toString());
  //       } else {
  //         throw 'Could not launch WhatsApp';
  //       }
  //     } catch (e) {
  //       print('Error sharing document: $e');
  //     }
  //   } else {
  //     print('Error: File path or phone number is empty');
  //   }
  // }

  Future<void> shareDocument(String url, String phoneNumber) async {
    if (url.isNotEmpty && phoneNumber.isNotEmpty) {
      try {
        // Download the file if necessary
        final filePath = await downloadFile(url: url);

        // Construct the WhatsApp message
        String message = "Here's the document: $url";

        // Construct the WhatsApp URL
        String whatsappUrl =
            "whatsapp://send?phone=91$phoneNumber&text=${Uri.encodeFull(message)}";

        // Launch WhatsApp
        if (await canLaunch(whatsappUrl)) {
          await launch(whatsappUrl);
        } else {
          throw 'Could not launch WhatsApp';
        }
      } catch (e) {
        print('Error sharing document: $e');
      }
    } else {
      print('Error: File path or phone number is empty');
    }
  }

  Future<PermissionStatus> _requestPermissions() async {
    final status = await Permission.storage.request();
    return status;
  }

  Future<String?> downloadFile({required String url}) async {
    try {
      final directory = await getExternalStorageDirectory();
      final path = '${directory!.path}/downloaded_document.pdf';
      final file = File(path);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return path;
      } else {
        print('Error downloading file: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }
}
