import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ghl_callrecoding/models/report_lead_models.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';

class ReportRepository {
  Future<ReportResponse> createReport(
      {required String leadId, required String reportNotes}) async {
    var url =
        Uri.parse("https://sales.ghlindia.com/api/sales-person/leads/report");
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    };

    var request = http.MultipartRequest('POST', url);
    request.fields['lead_id'] = leadId;
    request.fields['report_note'] = reportNotes;
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        Map<String, dynamic> json = jsonDecode(responseBody);
        print("response body======>${json}");
        return ReportResponse.fromJson(json);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }
}
