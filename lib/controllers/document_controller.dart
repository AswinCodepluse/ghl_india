import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/document_model.dart';
import 'package:ghl_callrecoding/repositories/document_repository.dart';

class DocumentController extends GetxController {
  RxList<DocumentData> documentList = <DocumentData>[].obs;
  RxBool loadingState = false.obs;

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
    loadingState.value = true;
    final response = await DocumentRepository().fetchDocument();
    loadingState.value = false;
    documentList.addAll(response.data!);
  }
}
