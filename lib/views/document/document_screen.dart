import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/document_controller.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/models/document_model.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class DocumentScreen extends StatelessWidget {
  DocumentScreen({super.key, required this.phoneNUmber});

  final String phoneNUmber;
  final DocumentController documentController = Get.put(DocumentController());
  final LeadsController leadsController = Get.find<LeadsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Documents'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return documentController.loadingState.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )
                    : documentController.documentList.isEmpty
                        ? Center(child: CustomText(text: "No Document Found"))
                        : ListView.builder(
                            itemCount: documentController.documentList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  documentController.documentList[index];
                              return documentContainer(data: data);
                            });
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget documentContainer({required DocumentData data}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image(image: AssetImage("assets/image/doc_icon.png")),
            SizedBox(
              width: 10,
            ),
            SizedBox(
                width: 180,
                child: CustomText(
                  text: data.name ?? "",
                  maxLines: 2,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                )),
            Spacer(),
            GestureDetector(
                onTap: () async {
                  print(phoneNUmber);
                  String leadPhoneNumber = '';
                  if (phoneNUmber.startsWith('+91')) {
                    leadPhoneNumber = phoneNUmber.replaceFirst('+91', '');
                  } else {
                    leadPhoneNumber = phoneNUmber;
                  }
                  await leadsController.shareDocument(
                    data.file!,
                    leadPhoneNumber,
                  );
                  // leadsController.shareDocument(
                  //     phoneNumber: leadPhoneNumber, url: data.file!);
                },
                child: Image(image: AssetImage("assets/image/share_icon.png")))
          ],
        ),
      ),
    );
  }
}
