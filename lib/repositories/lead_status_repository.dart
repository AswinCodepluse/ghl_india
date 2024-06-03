import 'dart:convert';

import 'package:ghl_callrecoding/app_config.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/models/leads_filter_models.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:http/http.dart' as http;

class LeadStatusRepository {
  Future<LeadsFilterResponse> fetchFilterLeadStatus(
      {int? id, required String filterBy}) async {
    var post_body = jsonEncode({"status": '$id', "filter": filterBy});
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
        print("Response body=-=========>${response.body}");
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

  Future<LeadsFilterResponse> fetchFilterLeadsSeasons() async {
    var post_body = jsonEncode({"filter": 'today'});
    print("post_body leads Seasons------>$post_body");

    var url = Uri.parse(
        "${AppConfig.BASE_URL}/sales-person/leads/status/filter/today");
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
