import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

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
}
