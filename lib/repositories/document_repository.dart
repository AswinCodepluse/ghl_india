import 'dart:convert';

import 'package:ghl_callrecoding/models/document_model.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:http/http.dart' as http;

class DocumentRepository {
  Future<DocumentModel> fetchDocument() async {
    Uri url =
        Uri.parse("https://sales.ghlindia.com/api/sales-person/all-documents");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
      },
    );
    print("Document data Response=========>${response.body}");
    return DocumentModel.fromJson(jsonDecode(response.body));
  }
}
