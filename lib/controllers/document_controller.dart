import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/document_model.dart';
import 'package:ghl_callrecoding/repositories/document_repository.dart';

class DocumentController extends GetxController {
  RxList<DocumentData> documentList = <DocumentData>[].obs;

  @override
  void onInit() {
    fetchDocument();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  fetchDocument() async {
    final response = await DocumentRepository().fetchDocument();
    documentList.addAll(response.data!);
  }
}
