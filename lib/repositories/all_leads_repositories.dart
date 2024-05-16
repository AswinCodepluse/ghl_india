import 'dart:convert';

import 'package:ghl_callrecoding/models/lead_datas_create_model.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'dart:io';
import '../models/all_leads_models.dart';
import 'package:http/http.dart' as http;

import '../models/lead_details.dart';
import '../utils/shared_value.dart';

class Dashboard {
  Future<List<AllLeads>> fetchLeads() async {
    final response = await http.get(
      Uri.parse('https://sales.ghlindia.com/api/sales-person'),
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );
    print("response Leads---->${response.body}");

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      return list.map((model) => AllLeads.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load leads');
    }
  }

  Future<List<Data>> fetchLeadStatus() async {
    final response = await http.get(
      Uri.parse('https://sales.ghlindia.com/api/sales-person/leads/status'),
      headers: {
        "Authorization": "Bearer ${access_token.$}",
      },
    );
    print("response Leads---->${response.body}");

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['data'];
      return list.map((model) => Data.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load leads');
    }
  }

  Future<LeadDetails> fetchOIndividualLeads(int? id) async {
    var post_body = jsonEncode({"id": "$id"});

    var url =
        Uri.parse("https://sales.ghlindia.com/api/sales-person/leads/show");
    try {
      // Make the POST request
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
          "Authorization": "Bearer ${access_token.$}",
        },
        body: post_body,
      );
      print("lead details response===========>${response.body}");
      // Check the status code of the response
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        Map<String, dynamic> json = jsonDecode(response.body);
        return LeadDetails.fromJson(json);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        // Return a default LoginResponse or throw an exception
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here if needed
      print('Exception occurred: $e');
      throw e; // Rethrow the exception
    }
  }


  Future<LeadDatasCreate> postLeadDatas(int? leadId,int? userId,int? oldStatus,int status,String testNotes,String date,File files,File callRecord) async {
    var post_body = jsonEncode({'lead_id': '$leadId',
      'user_id': '$userId',
      'old_status': '$oldStatus',
      'status': '$status',
      'notes': '$testNotes',
      'next_follow_up_date': '$date',
      'file': "$files",
      'call_record' : "$callRecord"
    });

    var url =
    Uri.parse("https://sales.ghlindia.com/api/sales-person/leads/activity/store");
    try {
      // Make the POST request
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
          "Authorization": "Bearer ${access_token.$}",
        },
        body: post_body,
      );
      print("lead create response===========>${response.body}");
      // Check the status code of the response
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        // Map<String, dynamic> json = jsonDecode(response.body);
        // return LeadDetails.fromJson(json);
        return leadDatasCreateResponseFromJson(response.body);
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        // Return a default LoginResponse or throw an exception
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here if needed
      print('Exception occurred: $e');
      throw e; // Rethrow the exception
    }
  }

// Future<LeadDetails> fetchOIndividualLeads(id) async {
//   final response = await http
//       .get(Uri.parse('https://sales.ghlindia.com/api/sales-person/leads/show/$id'));
//   print("Response=======>${response.body}");
//
//   if (response.statusCode == 200) {
//     Map<String, dynamic> json = jsonDecode(response.body);
//     return LeadDetails.fromJson(json);
//   } else {
//     throw Exception('Failed to load leads');
//   }
// }
}
