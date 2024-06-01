import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/models/dashboard_model.dart';
import 'package:ghl_callrecoding/repositories/dashboard_repository.dart';

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

  fetchDashboardData(String season) async {
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

  Future<void> refreshData() async {
    dashboardCountList.clear();
    await fetchDashboardData(leadSeasons);
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
