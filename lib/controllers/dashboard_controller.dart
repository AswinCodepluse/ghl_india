import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/models/dashboard_model.dart';
import 'package:ghl_callrecoding/models/recording_files_model.dart';
import 'package:ghl_callrecoding/repositories/call_log_repository.dart';
import 'package:ghl_callrecoding/repositories/dashboard_repository.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class DashboardController extends GetxController {
  var dashboardCountList = [].obs;
  var searchLeadsList = <AllLeads>[].obs;
  var googleLead = 0.obs;
  var websiteLead = 0.obs;
  var facebookLead = 0.obs;
  var totalLead = 0.obs;
  var whatsAppLead = 0.obs;
  var aiLead = 0.obs;
  var dpLead = 0.obs;
  var followUpTodayCallLater = 0.obs;
  var followUpTodayInterested = 0.obs;
  var followUpTodayKYCFill = 0.obs;
  String leadSeasons = '';
  TextEditingController searchCon = TextEditingController();
  TextEditingController callRecordingFolderCon = TextEditingController();
  RxList<FileSystemEntity> recordedFiles = <FileSystemEntity>[].obs;
  String? callRecordingDirPath;
  RxString userName = ''.obs;
  List<RecordingFileData> callRecordingFilesList = [];
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  appPermission() async {
    await Permission.storage.request();
    await Permission.contacts.request();
    await Permission.phone.request();
    await Permission.microphone.request();
  }

  fetchDashboardData(String season) async {
    var folderPath = await SharedPreference().getCallRecordingFolderPath();
    if (folderPath != '') {
      callRecordingFolderCon.text = folderPath;
    }
    isLeads.value = true;
    dashboardCountList.clear();
    var response = await DashboardRepository().fetchDashboardCount(season);
    DashBoardModel dashboardData = DashBoardModel.fromJson(response);
    googleLead.value = dashboardData.google!;
    websiteLead.value = dashboardData.website!;
    facebookLead.value = dashboardData.facebook!;
    totalLead.value = dashboardData.total!;
    whatsAppLead.value = dashboardData.whatsapp!;
    aiLead.value = dashboardData.aiChat!;
    dpLead.value = dashboardData.dp!;
    dashboardData.followUpToday?.forEach((element) {
      element.data?.forEach((data) {
        if (data.id == 4) {
          followUpTodayCallLater.value = data.count!;
        }
        if (data.id == 7) {
          followUpTodayKYCFill.value = data.count!;
        }
        if (data.id == 5) {
          followUpTodayInterested.value = data.count!;
        }
      });
    });
    dashboardData.leadStatus?.forEach((element) {
      element.data?.forEach((element) {
        dashboardCountList.add(element);
      });
    });
    isLeads.value = false;
    update();
  }

  Future<void> fetchRecordingFiles() async {
    var response = await DashboardRepository().fetchRecordingFiles();
    callRecordingFilesList.addAll(response.data!);
  }

  Future<void> refreshData() async {
    dashboardCountList.clear();
    await fetchDashboardData(leadSeasons);
  }

  Future<void> pickFolderPath(BuildContext context) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      await SharedPreference().setCallRecordingFolderPath(selectedDirectory);
      callRecordingFolderCon.text = selectedDirectory;
      callRecordingDirPath = selectedDirectory;
      Navigator.pop(context);
      ToastComponent.showDialog("Folder Path Saved",
          gravity: Toast.center, duration: Toast.lengthLong);
    }
    update();
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
