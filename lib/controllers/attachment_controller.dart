import 'package:get/get.dart';
import 'package:ghl_callrecoding/repositories/attachment_repository.dart';

class AttachmentController extends GetxController {
  var attachmentList = [].obs;

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

  fetchAttachment() async {
    attachmentList.clear();
    var response = await AttachmentRepository().fetchAttachment();
    attachmentList.addAll(response);
  }
}
