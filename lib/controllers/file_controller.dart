import 'dart:io';

import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dashboard_controller.dart';

class FileController extends GetxController {
  RxList<FileSystemEntity> recordedFiles = <FileSystemEntity>[].obs;
  RxList<String> filePathsWithPhoneNumber = <String>[].obs;
  RxBool isLoading = false.obs;
  final dashboardController = Get.find<DashboardController>();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1), () {
      _checkPermission();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> _checkPermission() async {
    if (await Permission.storage.request().isGranted) {
      _findRecordedFiles();
    }
  }

  openFile(filePath) {
    OpenFile.open(filePath);
  }

  Future<void> _findRecordedFiles() async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        Directory? directoryPath = Directory('/storage/emulated/0');
        List<FileSystemEntity> files = directoryPath.listSync(recursive: true);
        recordedFiles.value = files.where((file) {
          // String fileName = file.path.split('/').last;
          return (file.path.endsWith(".amr") ||
                  file.path.endsWith(".wav") ||
                  file.path.endsWith(".mp3") ||
                  file.path.endsWith(".m4a")) &&
              RegExp(r'^.*/\+\d{12}-\d{10}\.amr$').hasMatch(file.path);
        }).toList();

        print(recordedFiles);
        for (FileSystemEntity filePath in recordedFiles) {
          for (String phoneNumber in dashboardController.leadPhoneNumbers) {
            if ((filePath as File).path.contains(phoneNumber)) {
              filePathsWithPhoneNumber.add(filePath.path);
              break;
            }
          }
        }
        isLoading.value = false;
        update();
      }
    } catch (e) {
      print('Error finding recorded files: $e');
    }
  }
}
