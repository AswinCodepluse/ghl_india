import 'dart:convert';
import 'package:ghl_callrecoding/app_config.dart';
import 'package:ghl_callrecoding/models/filter_leads_model.dart';
import 'package:ghl_callrecoding/models/lead_datas_create_model.dart';
import 'package:ghl_callrecoding/models/lead_details_model.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'dart:io';
import '../models/all_leads_models.dart';
import 'package:http/http.dart' as http;

class Dashboard {
  Future<List<AllLeads>> fetchLeads() async {
    final response = await http.post(
      Uri.parse('https://sales.ghlindia.com/api/sales-person'),
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );
    print("response Leads all Data---->${response.body}");

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      return list.map((model) => AllLeads.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load leads');
    }
  }

  Future<FilterLeadsModel> fetchFilterLeads(
      {required String filterBy, required String session}) async {
    var post_body = jsonEncode({"filter": filterBy, "type": session});

    var url = Uri.parse("https://sales.ghlindia.com/api/sales-person");
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
        print('Response body ========= : ${response.body}');
        Map<String, dynamic> json = jsonDecode(response.body);
        return FilterLeadsModel.fromJson(json);
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

  Future<List<Data>> fetchLeadStatus() async {
    final response = await http.get(
      Uri.parse('https://sales.ghlindia.com/api/sales-person/leads/status'),
      headers: {
        "Authorization": "Bearer ${access_token.$}",
      },
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      return list.map((model) => Data.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load leads');
    }
  }

  Future<LeadDetails> fetchOIndividualLeads(int? id) async {
    var post_body = jsonEncode({"id": "$id"});

    var url = Uri.parse("${AppConfig.BASE_URL}/sales-person/leads/show");
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
        return LeadDetails.fromJson(json);
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

  Future<LeadDatasCreate> postLeadData(
    int? leadId,
    int? userId,
    int? oldStatus,
    int status,
    String testNotes,
    String date,
    String time,
    File files,
    File callRecord,
    File voiceRecord,
  ) async {
    var url = Uri.parse(
        "https://sales.ghlindia.com/api/sales-person/leads/activity/store");
    var headers = {
      "Content-Type": "application/json",
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    };
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'lead_id': '$leadId',
      'user_id': '$userId',
      'old_status': '$oldStatus',
      'status': '$status',
      'notes': '$testNotes',
      'next_follow_up_date': '$date',
      'next_follow_up_time': time
    });
    if (files.existsSync()) {
      request.files.add(http.MultipartFile(
          'file', files.readAsBytes().asStream(), files.lengthSync(),
          filename: files.path.split('/').last));
    }

    if (callRecord.existsSync()) {
      request.files.add(http.MultipartFile('call_record',
          callRecord.readAsBytes().asStream(), callRecord.lengthSync(),
          filename: callRecord.path.split('/').last));
    }
    if (voiceRecord.existsSync()) {
      request.files.add(http.MultipartFile('voice_record',
          voiceRecord.readAsBytes().asStream(), voiceRecord.lengthSync(),
          filename: voiceRecord.path.split('/').last));
    }

    request.headers.addAll(headers);

    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var response = await http.Response.fromStream(streamedResponse);
        return leadDatasCreateResponseFromJson(response.body);
      } else {
        print(
            'Failed to make POST request. Error: ${streamedResponse.reasonPhrase}');
        throw Exception(
            'Failed to make POST request. Error: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }
}
