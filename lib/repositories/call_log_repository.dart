import 'dart:convert';

import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/get_call_log_model.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CallLogRepository {
  Future<GetCallLogModel> postCallLog({
    required String leadId,
    required String userId,
    required String startTime,
    required String endTime,
    required String duration,
    required String type,
    required File callRecordingFile,
  }) async {
    print('postCallLog data =====================================>');
    print('leadId ${leadId}');
    print('userId ${userId}');
    print('startTime ${startTime}');
    print('endTime ${endTime}');
    print('duration ${duration}');
    print('type ${type}');
    print('callRecordingFile ${callRecordingFile}');
    print('postCallLog data =====================================>');
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
        Map<String, dynamic> json = jsonDecode(responseBody);
        print("post call  log response========>${responseBody}");
        return GetCallLogModel.fromJson(json);
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

  Future<GetCallLogModel> postCallLogForAdmin({
    required String phoneNumber,
    required String userId,
    required String startTime,
    required String endTime,
    required String duration,
    required String type,
    required File callRecordingFile,
  }) async {
    var url = Uri.parse(
        'https://sales.ghlindia.com/api/sales-person/lead/call-all-log/create');

    var request = http.MultipartRequest('POST', url);
    var token = '';

    request.fields['phone'] = phoneNumber;
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
    print('access_token ${access_token.$}');

    if (access_token.$ == '') {
      token = await SharedPreference().getToken() ?? '';
    } else {
      token = access_token.$ ?? '';
    }

    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${token}",
    });

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> json = jsonDecode(responseBody);
        print('call log All responseBody  $responseBody ');
        return GetCallLogModel.fromJson(json);
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
        print('responseBody get  $responseBody');
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

  Future<void> postCallRecordingFile({
    required String userId,
    required String dateTime,
    required File callRecordingFile,
  }) async {
    var url = Uri.parse(
        'https://sales.ghlindia.com/api/sales-person/lead/call-all-log-with-recordings/create');

    var request = http.MultipartRequest('POST', url);

    request.fields['user_id'] = userId;
    request.fields['date_time'] = dateTime;
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
        var responseBody = await response.stream.bytesToString();
        print('callFile  responseBody $responseBody ');
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
}
