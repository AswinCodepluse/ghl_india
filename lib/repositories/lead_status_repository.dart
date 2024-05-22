import 'dart:convert';

import 'package:ghl_callrecoding/app_config.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/models/leads_filter_models.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:http/http.dart' as http;

class LeadStatusRepository {
  Future<LeadsFilterResponse> fetchFilterLeadStatus() async {
    var post_body = jsonEncode({"status": '1'});

    var url =
        Uri.parse("${AppConfig.BASE_URL}/sales-person/leads/status/filter");
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
          "Authorization": "Bearer ${access_token.$}",
        },
        body: post_body,
      );
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        Map<String, dynamic> json = jsonDecode(response.body);
        return LeadsFilterResponse.fromJson(json);
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
