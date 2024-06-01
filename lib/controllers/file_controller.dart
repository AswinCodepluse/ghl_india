import 'dart:io';

import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/leads_controller.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dashboard_controller.dart';

class FileController extends GetxController {
  RxList<FileSystemEntity> recordedFiles = <FileSystemEntity>[].obs;
  RxList<String> filePathsWithPhoneNumber = <String>[].obs;
  RxBool isLoading = false.obs;
  final dashboardController = Get.find<DashboardController>();
  // final leadsDataController = Get.find<LeadsDataController>();
  LeadsDataController leadsDataController = Get.put(LeadsDataController());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  openFile(filePath) {
    OpenFile.open(filePath);
  }

  Future<void> checkPermission() async {
    FileController fileController = Get.put(FileController());
    if (await Permission.storage.request().isGranted) {
      fileController.findRecordedFiles();
    }
  }

  Future<void> findRecordedFiles() async {

    try {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        Directory? directoryPath = Directory('/storage/emulated/0');
        List<FileSystemEntity> files = directoryPath.listSync(recursive: true);
        recordedFiles.value = files.where((file) {
          return (file.path.endsWith(".amr") ||
              file.path.endsWith(".wav") ||
              file.path.endsWith(".mp3") ||
              file.path.endsWith(".m4a"));
        }).toList();
        filePathsWithPhoneNumber.clear();
        for (FileSystemEntity filePath in recordedFiles) {
          for (String phoneNumber in leadsDataController.leadPhoneNumbers) {
            if ((filePath as File).path.contains(phoneNumber)) {
              File audioFile = filePath;
              DateTime lastModified = await audioFile.lastModified();
              filePathsWithPhoneNumber.add(filePath.path);
              break;
            }
          }
        }
        update();
      }
    } catch (e) {
      print('Error finding recorded files: $e');
    }
  }
}
