import 'dart:convert';

import 'package:ghl_callrecoding/models/dashboard_model.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:http/http.dart' as http;

class DashboardRepository {
  Future<List<Data>> fetchDashboardCount() async {
    final response = await http.get(
      Uri.parse('https://sales.ghlindia.com/api/sales-person/dashboard'),
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
}
