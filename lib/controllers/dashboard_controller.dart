import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/models/dashboard_model.dart';
import 'package:ghl_callrecoding/repositories/dashboard_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardController extends GetxController {
  var dashboardCountList = [].obs;
  var searchLeadsList = <AllLeads>[].obs;
  var leadPhoneNumbers = <String>[].obs;
  var googleLead = 0.obs;
  var websiteLead = 0.obs;
  var facebookLead = 0.obs;
  var totalLead = 0.obs;
  String leadSeasons = '';
  TextEditingController searchCon = TextEditingController();
  TextEditingController callRecordingFileCon = TextEditingController();
  RxList<FileSystemEntity> recordedFiles = <FileSystemEntity>[].obs;
  String? callRecordingDirPath;
  var colors = [
    'blue',
    'orange',
    'green',
    'yellow',
    'purple',
    'pink',
    'cyan',
    'brown',
    'teal'
  ];
  var isLeads = false.obs;

  Future<void> checkPermission() async {
    FileController fileController = Get.put(FileController());
    if (await Permission.storage.request().isGranted) {
      fileController.findRecordedFiles();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    // fetchDashboardData(leadSeasons);

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  fetchDashboardData(String season) async {
    isLeads.value = true;
    dashboardCountList.clear();
    var response = await DashboardRepository().fetchDashboardCount(season);
    DashboardModel dashboardData = DashboardModel.fromJson(response);
    googleLead.value = dashboardData.google!;
    websiteLead.value = dashboardData.website!;
    facebookLead.value = dashboardData.facebook!;
    totalLead.value = dashboardData.total!;
    dashboardData.leadStatus?.forEach((element) {
      element.data?.forEach((element) {
        dashboardCountList.add(element);
      });
    });
    isLeads.value = false;
    update();
  }

  Future<void> refreshData() async {
    dashboardCountList.clear();
    await fetchDashboardData(leadSeasons);
  }

  Future<void> pickFile() async {
    String? result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      callRecordingDirPath = result;
      await storeRecordedFiles(callRecordingDirPath!);
      callRecordingFileCon.text = callRecordingDirPath!;
      update();
    }
  }

  Future<String> getFilePath() async {
    String? filePath;
    try {
      filePath = await StoragePath.audioPath;
      var response = jsonDecode(filePath!);
      List res = response;
      res.forEach((e) => print("file path $e"));
      print('-------------------------');
      print("response $res");

      print('-------------------------');
      print(response);
    } on PlatformException {
      filePath = 'Failed to get path';
    }
    return filePath;
  }

  Future<void> storeRecordedFiles(String callRecordingDirPath) async {
    try {
      Directory? directoryPath = Directory(callRecordingDirPath);
      List<FileSystemEntity> files = directoryPath.listSync(recursive: true);
      print('files  $files');
      recordedFiles.value = files.where((file) {
        return file is File &&
            (file.path.endsWith(".amr") ||
                file.path.endsWith(".wav") ||
                file.path.endsWith(".mp3") ||
                file.path.endsWith(".m4a"));
      }).toList();

      print("recordedFiles  $recordedFiles");
      update();
    } catch (e) {
      print('Error finding recorded files: $e');
    }
  }

  Color getColor(String colorName) {
    switch (colorName) {
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      case 'brown':
        return Colors.brown;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.black;
    }
  }
}
