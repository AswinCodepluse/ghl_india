import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/firebase/firebase_repository.dart';
import 'package:ghl_callrecoding/models/lead_datas_create_model.dart';
import 'package:ghl_callrecoding/models/lead_details_model.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class LeadsController extends GetxController {
  var isLeads = false.obs;
  RxString fileName = ''.obs;
  var selectedLeadIds = 0.obs;
  var selectedLeadNames = ''.obs;
  TextEditingController fileCon = TextEditingController();
  TextEditingController statusCon = TextEditingController();
  TextEditingController followupNotesCon = TextEditingController();
  TextEditingController investDateCon = TextEditingController();
  TextEditingController investTypeCon = TextEditingController();
  TextEditingController transactionIdCon = TextEditingController();
  TextEditingController dateTimeCon = TextEditingController();
  TextEditingController timeCon = TextEditingController();
  TextEditingController amountCon = TextEditingController();
  var leadStatusList = <Data>[].obs;
  RxList<String> leadStatusNameList = <String>[].obs;
  RxString selectedLeadStatus = ''.obs;
  RxInt isInvestor = 0.obs;

  // RxInt leadId = 0.obs;
  RxString message = ''.obs;
  File lastCallRecording = File("");
  File? files;
  bool isSubmitted = false;
  String hours = '';
  String minutes = '';
  RxBool loadingState = false.obs;
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
    fetchLeadStatus();

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
    if ((followupNotesCon.text.isEmpty || followupNotesCon.text == '') ||
        (selectedLeadIds == 10 &&
            (amountCon.text.isEmpty ||
                amountCon.text == '' ||
                investTypeCon.text.isEmpty ||
                investTypeCon.text == '' ||
                investDateCon.text.isEmpty ||
                investDateCon.text == '' ||
                transactionIdCon.text.isEmpty ||
                transactionIdCon.text == ''))) {
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

  Future<void> displayDatePicker(BuildContext context, dateValue) async {
    DateTime date = DateTime(1900);
    FocusScope.of(context).requestFocus(FocusNode());
    date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)) as DateTime;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    dateValue.text = formatter.format(date);
    investDateCon.text = formatter.format(date);
    remindDate = dateValue.text;
    isDisable();
    update();
  }

  Future dateTimePicker(BuildContext context) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    if (dateTime != null) {
      String desiredFormat = "yyyy-MM-dd HH:mm";
      dateTimeCon.text = DateFormat(desiredFormat).format(dateTime);
      FirebaseRepository().sendPushNotification(
                  "f3OFDmxCRXG4MIziiyvfvb:APA91bFjKktivZ80f9O_Sd-RNHE-9zImohq6PGqADd1mCd3hjRX5eSr3hjaOMkOqJQQNLSVA6Sf1A8FCL0a6rT7B5CJzNoace2QtREs7dyDNqutZ-xOtrLxYftFpRaruF5qZQ88GbCnZ",
                  "test test test");
    }
  }

  void onChangeStatus(value){

    selectedLeadIds.value = value!.id!;
    selectedLeadNames.value = value.name!;
    print('selectedLeadIds  ${selectedLeadIds.value}');
   amountCon.clear();
    investDateCon.clear();
    investTypeCon.clear();
    isDisable();
  }

  // Future dateTimePicker(BuildContext context) async {
  //   return DatePicker.showDateTimePicker(context,
  //       showTitleActions: true,
  //       minTime: DateTime(2000, 1, 1),
  //       maxTime: DateTime(4000, 12, 31), onConfirm: (date) {
  //     String desiredFormat = "yyyy-MM-dd HH:mm";
  //     dateTimeCon.text = DateFormat(desiredFormat).format(date);
  //     print('dateTimeCon  ${dateTimeCon.text}');
  //     FirebaseRepository().sendPushNotification(
  //         "f3OFDmxCRXG4MIziiyvfvb:APA91bFjKktivZ80f9O_Sd-RNHE-9zImohq6PGqADd1mCd3hjRX5eSr3hjaOMkOqJQQNLSVA6Sf1A8FCL0a6rT7B5CJzNoace2QtREs7dyDNqutZ-xOtrLxYftFpRaruF5qZQ88GbCnZ",
  //         "test test test");
  //     update();
  //   }, currentTime: DateTime.now(), locale: LocaleType.en);
  // }

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

  clearAll() {
    fileCon.clear();
    followupNotesCon.clear();
    callRecordingFileCon.clear();
    investDateCon.clear();
    dateTimeCon.clear();
    timeCon.clear();
    amountCon.clear();
    investTypeCon.clear();
    transactionIdCon.clear();
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
    String transactionId,
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
          voiceRecord,
          transactionId,
          amountCon.text,
          investTypeCon.text,
          investDateCon.text);
      message.value = response.message!;
      return response;
    } catch (e) {
      message.value = "Failed To Update Lead Status";
      throw "$e";
    } finally {
      loadingState.value = false;
    }
  }

  fetchIndividualLeads(int id) async {
    leadDetailsData.value = await Dashboard().fetchOIndividualLeads(id);
    isInvestor.value = leadDetailsData.value.isInvestor!;
    // leadId.value = leadDetailsData.value.id!;
    selectedLeadIds.value = leadDetailsData.value.statusInt!;
  }

  fetchLeadStatus() async {
    isLeads.value = true;
    var leadsResponse = await Dashboard().fetchLeadStatus();
    leadStatusList.addAll(leadsResponse);
    leadStatusNameList.clear();

    for (int i = 0; i < leadStatusList.length; i++) {
      leadStatusNameList.add(leadStatusList[i].name!);
    }

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

  Future<void> launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(emailUri.toString())) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $email';
    }
  }

  openWhatsApp(context, phoneNumber) async {
    var whatsapp = "+91$phoneNumber";

    var whatsappURl_android = "whatsapp://send?phone=$whatsapp";
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

  fetchLastCallRecordingFile(String phoneNumber) async {
    if (fileController.filePathsWithPhoneNumber.isNotEmpty) {
      if (fileController.filePathsWithPhoneNumber.last.contains(phoneNumber)) {
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
        final filePath = await downloadFile(url: url);
        String message = "Here's the document: $url";
        String whatsappUrl =
            "whatsapp://send?phone=91$phoneNumber&text=${Uri.encodeFull(message)}";
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
