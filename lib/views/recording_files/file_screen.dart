import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({Key? key}) : super(key: key);

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  FileController fileController = Get.put(FileController());

  @override
  void initState() {
    super.initState();
    // fileController.findRecordedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Files'),
      ),
      body: Obx(() {
        return fileController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : fileController.callRecordingFilesList.isEmpty
                ? const Center(child: Text('No recorded files found'))
                : ListView.builder(
                    // itemCount: fileController.recordedFiles.length,
                    itemCount: fileController.callRecordingFilesList.length,
                    itemBuilder: (context, index) {
                      // String fileName = fileController
                      //     .filePathsWithPhoneNumber[index]
                      //     .split('/')
                      //     .last;
                      // print(
                      //     'file path  ${fileController.filePathsWithPhoneNumber[index]}');
                      return ListTile(
                        title: Text(fileController.callRecordingFilesList[index].toString()),
                        onTap: () {
                          fileController.openFile(
                              fileController.callRecordingFilesList[index]);
                        },
                      );
                    },
                  );
      }),
    );
  }
}
