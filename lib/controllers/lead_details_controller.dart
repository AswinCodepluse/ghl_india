import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadsController extends GetxController {
  var isLeads = false.obs;
  RxString fileName=''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchAll();
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
    // leadsList.clear();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      fileName.value = file.path.split('/').last;
      update();
    } else {
      // User canceled the picker
    }
  }
  openWhatsApp(context,phoneNumber) async {
    var whatsapp = "+91$phoneNumber";
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
}
