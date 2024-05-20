import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/firebase/firebase_repository.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/lead_details_model.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadsController extends GetxController {
  var isLeads = false.obs;
  RxString fileName = ''.obs;
  var selectedLeadIds = 0.obs;
  var selectedLeadNames = ''.obs;
  TextEditingController fileCon = TextEditingController();
  TextEditingController statusCon = TextEditingController();
  TextEditingController followupNotesCon = TextEditingController();
  TextEditingController datePickedCon = TextEditingController();
  var leadStatusList = <Data>[].obs;
  RxList<String> leadStatusNameList = <String>[].obs;
  RxString selectedLeadStatus = ''.obs;
  File lastCallRecording = File("");
  RxString selectedLeadPhoneNumber = ''.obs;
  File? files;
  bool isSubmitted = false;
  // var leadDetailsData = Rx<LeadDetails?>(LeadDetails);
  Rx<LeadDetails> leadDetailsData = LeadDetails().obs;


  File callFiles = File("");
  var setDisable = true.obs;
  TextEditingController callRecordingFileCon = TextEditingController();
  TextEditingController pathSetupCon = TextEditingController();
  RxString callFileName = ''.obs;
  String token = '';
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
      SharedPreference().setRemainderDate(remindDate);
      FirebaseRepository().setNotification();
     update();
    }
  }

  setNotification() async {
    String dateString = datePickedCon.text;
    List<String> dateParts = dateString.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    FirebaseRepository firebaseRepo = FirebaseRepository();
    await firebaseRepo.getToken().then((value) => token = value);
    final targetDateTime = DateTime(year, month, day, 10, 00);
    firebaseRepo.scheduleNotificationAtSpecificTime(targetDateTime, token);
  }

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
        callFileName.value = callFiles!.path.split('/').last;
        callRecordingFileCon.text = callFiles!.path.split('/').last;
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



  fetchIndividualLeads(int id) async {
    leadDetailsData.value = await Dashboard().fetchOIndividualLeads(id);
    selectedLeadIds.value =
    leadDetailsData.value.statusInt!;
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
}
