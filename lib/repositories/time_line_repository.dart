import 'dart:convert';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:http/http.dart' as http;
import 'package:ghl_callrecoding/models/time_line_model.dart';

class TimeLineRepository {
  Future<List<dynamic>> fetchTimeLine(int? id) async {
    var post_body = jsonEncode({"lead_id": "$id"});

    var url =
        Uri.parse("https://sales.ghlindia.com/api/sales-person/leads/activity");
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
        },
        body: post_body,
      );

      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response body: ${response.body}');
        var json = jsonDecode(response.body)["data"];
        return json.map((e) => Data.fromJson(e)).toList();
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
