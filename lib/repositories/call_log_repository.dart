import 'dart:convert';

import 'package:ghl_callrecoding/models/get_call_log_model.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CallLogRepository {
  Future<void> postCallLog({
    required String leadId,
    required String userId,
    required String startTime,
    required String endTime,
    required String duration,
    required String type,
    required File callRecordingFile,
  }) async {
    var url = Uri.parse(
        'https://sales.ghlindia.com/api/sales-person/lead/call-log/create');

    var request = http.MultipartRequest('POST', url);

    request.fields['lead_id'] = leadId;
    request.fields['user_id'] = userId;
    request.fields['start_time'] = startTime;
    request.fields['end_time'] = endTime;
    request.fields['duration'] = duration;
    request.fields['type'] = type;

    if (callRecordingFile.existsSync()) {
      request.files.add(http.MultipartFile(
          'file',
          callRecordingFile.readAsBytes().asStream(),
          callRecordingFile.lengthSync(),
          filename: callRecordingFile.path.split('/').last));
    }
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
      } else {
        String responseBody = await response.stream.bytesToString();
        print(
            'Failed to make POST request. Status code: ${response.statusCode}');
        print('Response body: $responseBody');
        throw Exception(
            'Failed to make POST request. Status code: ${response.statusCode}. Response body: $responseBody');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw e;
    }
  }

  Future<GetCallLogModel> getCallLog(String leadId) async {
    var url = Uri.parse(
        "https://sales.ghlindia.com/api/sales-person/lead/get-call-log-details");
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    };

    var request = http.MultipartRequest('POST', url);
    request.fields['lead_id'] = leadId;
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> json = jsonDecode(responseBody);
        return GetCallLogModel.fromJson(json);
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
