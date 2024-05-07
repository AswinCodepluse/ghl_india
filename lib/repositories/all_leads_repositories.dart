import 'dart:convert';

import '../models/all_leads_models.dart';
import 'package:http/http.dart' as http;

import '../models/lead_details.dart';

class Dashboard{

  Future<List<AllLeads>> fetchLeads() async {
    final response = await http.get(Uri.parse('https://crm.ghlindia.com/leadsapi/lead-categories/'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => AllLeads.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load leads');
    }
  }

  Future<LeadDetails> fetchOIndividualLeads(phone) async {
    final response = await http.get(Uri.parse('https://crm.ghlindia.com/leadsapi/lead/$phone/'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return LeadDetails.fromJson(json);
    } else {
      throw Exception('Failed to load leads');
    }
  }
}