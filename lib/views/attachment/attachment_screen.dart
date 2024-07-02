import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/attachment_controller.dart';
import 'package:ghl_callrecoding/views/attachment/widget/attachment_container.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class AttachmentScreen extends StatelessWidget {
  const AttachmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AttachmentController attachmentController = Get.put(AttachmentController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.transparent,
        title: Text("Attachment"),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              attachmentController.attachmentList.isEmpty
                  ? Center(child: CustomText(text: "No Attachment Found"))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: attachmentController.attachmentList.length,
                          itemBuilder: (context, index) {
                            final data =
                                attachmentController.attachmentList[index];
                            return attachmentContainer(data);
                          }),
                    ),
            ],
          );
        }),
      ),
    );
  }
}
