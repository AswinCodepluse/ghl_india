import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadsController extends GetxController {
  var isLeads = false.obs;
  RxString fileName = ''.obs;
  var selectedLeadIds = 0.obs;
  TextEditingController fileCon = TextEditingController();
  TextEditingController statusCon = TextEditingController();
  TextEditingController followupNotesCon = TextEditingController();
  var leadStatusList = <Data>[].obs;
  RxList<String> leadStatusNameList = <String>[].obs;
  RxString selectedLeadStatus = ''.obs;
  File lastCallRecording = File("");
  RxString selectedLeadPhoneNumber = ''.obs;
  File? files;

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

  fetchAllLeadsDatas() async {
    isLeads.value = true;
    // var leadsResponse = await Dashboard().fetchLeads();
    // leadsList.addAll(leadsResponse);
    isLeads.value = false;
    update();
  }

  fetchAll() {
    fetchAllLeadsDatas();
  }

  clearAll() {
    fileCon.clear();
    followupNotesCon.clear();
    // leadsList.clear();
  }

  onChanged(String? newValue) {
    selectedLeadStatus.value = newValue!;
    update();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      files = File(result.files.single.path!);
      fileName.value = files!.path.split('/').last;
      fileCon.text = files!.path.split('/').last;
      update();
    } else {
      // User canceled the picker
    }
  }

  // Future fetchLeadStatus() async {
  //   List<LeadStatusModel> data = await Dashboard().fetchLeadStatus();
  //  print('================================');
  //  print(data.first.data![0].name);
  //  print('================================');
  // }
  // fetchLeadStatus() async {
  //   isLeads.value = true;
  //   var leadsResponse = await Dashboard().fetchLeadStatus();
  //   leadStatusList.addAll(leadsResponse);
  //
  //   for (int i = 0; i < leadStatusList.length; i++) {
  //     leadStatusNameList.add(leadStatusList[i].name!);
  //   }
  //   print('================================');
  //   print(leadStatusList[0].name);
  //   print('================================');
  //   isLeads.value = false;
  //   update();
  // }

  fetchIndividualLeads(int id) async {
    var leadsDataResponse = await Dashboard().fetchOIndividualLeads(id);
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
      print('phoneNumber ========= $phoneNumber');
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
    print('+++++++++++++++++++++++++++=');
    print(fileController.filePathsWithPhoneNumber);
    print('+++++++++++++++++++++++++++=');
    if (fileController.filePathsWithPhoneNumber.isNotEmpty) {
      if (fileController.filePathsWithPhoneNumber.last
          .contains(selectedLeadPhoneNumber)) {
        lastCallRecording = File(fileController.filePathsWithPhoneNumber.last);
        print('lastCallRecording $lastCallRecording');
      }
    }
  }
}
