import 'dart:convert';
import 'package:ghl_callrecoding/app_config.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:http/http.dart' as http;

class DashboardRepository {
  Future<Map<String, dynamic>> fetchDashboardCount(String seasons) async {

    var post_body = jsonEncode({"filter": '${seasons}'});
    print("post_body Dashboard Seasons------>$post_body");

    var url =
    Uri.parse("${AppConfig.BASE_URL}/sales-person/dashboard");
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
        print("response Dashboard : ${response.body}");
        Map<String, dynamic> dashboardData = json.decode(response.body);
        return dashboardData;
      } else {
        print('Failed to make POST request. Error: ${response.statusCode}');
        throw Exception(
            'Failed to make POST request. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
    // final response = await http.get(
    //   Uri.parse('https://sales.ghlindia.com/api/sales-person/dashboard'),
    //   headers: {
    //     "Authorization": "Bearer ${access_token.$}",
    //   },
    // );
    // print("response Leads : ${response.body}");
    //
    // if (response.statusCode == 200) {
    //   Map<String, dynamic> dashboardData = json.decode(response.body);
    //   return dashboardData;
    // } else {
    //   throw Exception('Failed to load leads');
    // }
  }
}
