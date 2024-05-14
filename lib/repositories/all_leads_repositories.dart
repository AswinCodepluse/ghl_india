import 'dart:convert';

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
