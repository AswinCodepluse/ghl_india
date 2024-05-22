import 'package:flutter/material.dart';
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
  TextEditingController searchCon = TextEditingController();
  var colors = [
    'red',
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
    fetchDashboardData();
    Future.delayed(Duration(seconds: 1), () {
      checkPermission();
    });

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  fetchDashboardData() async {
    isLeads.value = true;
    dashboardCountList.clear();
    var response = await DashboardRepository().fetchDashboardCount();
    DashboardModel dashboardData = DashboardModel.fromJson(response);
    googleLead.value = dashboardData.google!;
    websiteLead.value = dashboardData.website!;
    facebookLead.value = dashboardData.facebook!;
    totalLead.value = dashboardData.total!;
    dashboardData.leadStatus?.data?.forEach((element) {
      dashboardCountList.add(element);
    });
    isLeads.value = false;
    update();
  }

  Future<void> refreshData() async {
    dashboardCountList.clear();
    await fetchDashboardData();
  }

  Color getColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
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
