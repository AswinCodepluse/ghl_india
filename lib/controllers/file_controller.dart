import 'dart:io';

import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dashboard_controller.dart';

class FileController extends GetxController {
  RxList<FileSystemEntity> recordedFiles = <FileSystemEntity>[].obs;
  RxList<String> filePathsWithPhoneNumber = <String>[].obs;
  RxBool isLoading = false.obs;
  final dashboardController = Get.find<DashboardController>();

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

  Future<void> findRecordedFiles() async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        print('====================================');
        Directory? directoryPath = Directory('/storage/emulated/0');
        List<FileSystemEntity> files = directoryPath.listSync(recursive: true);
        print('files $files');
        recordedFiles.value = files.where((file) {
          return (file.path.endsWith(".amr") ||
              file.path.endsWith(".wav") ||
              file.path.endsWith(".mp3") ||
              file.path.endsWith(".m4a"));
        }).toList();
        for (FileSystemEntity filePath in recordedFiles) {
          for (String phoneNumber in dashboardController.leadPhoneNumbers) {
            print('phoneNumber $phoneNumber');
            if ((filePath as File).path.contains(phoneNumber)) {
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
