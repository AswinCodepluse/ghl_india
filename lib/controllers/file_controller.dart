import 'dart:io';

import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/leads_controller.dart';
import 'package:ghl_callrecoding/local_db/hive_db/call_recording_file_hive_model.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dashboard_controller.dart';

class FileController extends GetxController {
  RxList<FileSystemEntity> recordedFiles = <FileSystemEntity>[].obs;

  // RxList<FileSystemEntity> callRecordingFilesList = <FileSystemEntity>[
  //   File(
  //       "/storage/emulated/0/Recordings/Call/CallRecording_+919519020825_240619_124742.m4a"),
  //   File(
  //       "/storage/emulated/0/Recordings/Call/CallRecording_+919519020825_240618_225921.m4a"),
  //   File(
  //       "/storage/emulated/0/Recordings/Call/CallRecording Aswin_240617_124742.m4a"),
  //   File(
  //       "/storage/emulated/0/Recordings/Call/CallRecording Ketan_240624_121620.m4a"),
  //   File(
  //       "/storage/emulated/0/Recordings/Call/CallRecording_+919519020825_240622_110701.m4a"),
  //   File(
  //       "/storage/emulated/0/Recordings/Call/CallRecording_+919519020825_240621_102246.m4a"),
  //   File(
  //       "/storage/emulated/0/Recordings/Call/CallRecording_+919822032418_240613_124742.m4a"),
  //   File(
  //       "/storage/emulated/0/Recordings/Call/CallRecording_+919664132060_240612_124742.m4a"),
  // ].obs;

  RxList<FileSystemEntity> callRecordingFilesList = <FileSystemEntity>[].obs;

  Box<CallRecordingHiveModel> callRecordingBox =
      Hive.box<CallRecordingHiveModel>('call_recordings');

  // RxList<String> filePathsWithPhoneNumber = <String>[].obs;
  RxBool isLoading = false.obs;
  // final dashboardController = Get.find<DashboardController>();
  LeadsDataController leadsDataController = Get.put(LeadsDataController());
  DashboardController dashboardController = Get.put(DashboardController());

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
      await fileController.findRecordedFiles();
    }
  }

  Future<void> saveCallRecordingFiles(File file) async {
    callRecordingBox.add(CallRecordingHiveModel(
        filePath: file.path, timestamp: file.lastModifiedSync()));
  }

  Future<void> findRecordedFiles() async {
    String callRecordingDirPath =
        await SharedPreference().getCallRecordingFolderPath();
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        if (callRecordingDirPath != '') {
          Directory? directoryPath = Directory(callRecordingDirPath);
          callRecordingFilesList.value =
              directoryPath.listSync(recursive: true);
          for (var file in callRecordingFilesList) {
            bool fileExists = callRecordingBox.values
                .any((recording) => recording.filePath == file.path);
            bool fileExistsDB =
                dashboardController.callRecordingFilesList.any((element) {
              // var dateTime = File(file.path).lastModifiedSync();
              // DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
              // String timeStamp = formatter.format(dateTime);
              return element.filePath == element.filePath;
            });

            if (!fileExists && !fileExistsDB) {
              await saveCallRecordingFiles(File(file.path));
            }
          }

          // List<CallRecordingHiveModel> fileList =
          //     callRecordingFilesList.map((file) {
          //   return CallRecordingHiveModel(
          //     filePath: file.path,
          //     timestamp: File(file.path).lastModifiedSync(),
          //   );
          // }).toList();
        }
      }
      update();
    } catch (e) {
      print('Error finding recorded files: $e');
    }
  }
}
