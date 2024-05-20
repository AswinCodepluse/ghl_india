import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ghl_callrecoding/models/attachment_model.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';

class AttachmentRepository {
  Future<List<AttachmentData>> fetchAttachment() async {
    final response = await http.get(
      Uri.parse('https://sales.ghlindia.com/api/sales-person/all-documents'),
      headers: {
        "Authorization": "Bearer ${access_token.$}",
      },
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      return list.map((model) => AttachmentData.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load leads');
    }
  }
}
