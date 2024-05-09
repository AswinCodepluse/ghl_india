import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';

class FileScreen extends StatelessWidget {
  const FileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FileController fileController = Get.put(FileController());
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
            : fileController.filePathsWithPhoneNumber.isEmpty
                ? const Center(child: Text('No recorded files found'))
                : ListView.builder(
                    // itemCount: fileController.recordedFiles.length,
                    itemCount: fileController.filePathsWithPhoneNumber.length,
                    itemBuilder: (context, index) {
                      // String fileName = fileController.recordedFiles[index].path
                      //     .split('/')
                      //     .last;
                      String fileName = fileController
                          .filePathsWithPhoneNumber[index]
                          .split('/')
                          .last;
                      return ListTile(
                        title: Text(fileName),
                        onTap: () {
                          fileController.openFile(
                              fileController.recordedFiles[index].path);
                        },
                      );
                    },
                  );
      }),
    );
  }
}
