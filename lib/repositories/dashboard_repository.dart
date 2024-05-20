import 'dart:convert';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:http/http.dart' as http;

class DashboardRepository {
  Future<Map<String, dynamic>> fetchDashboardCount() async {
    final response = await http.get(
      Uri.parse('https://sales.ghlindia.com/api/sales-person/dashboard'),
      headers: {
        "Authorization": "Bearer ${access_token.$}",
      },
    );
    print("response Leads : ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> dashboardData = json.decode(response.body);
      return dashboardData;
    } else {
      throw Exception('Failed to load leads');
    }
  }
}
