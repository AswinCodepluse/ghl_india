import 'dart:convert';

import 'package:ghl_callrecoding/models/get_transaction_model.dart';
import 'package:ghl_callrecoding/models/post_transaction_models.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:http/http.dart' as http;

class TransactionRepository {
  Future<GetTransactionModel> getTransaction(String leadId) async {
    var url = Uri.parse(
        "https://sales.ghlindia.com/api/sales-person/lead/get-transactions");
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
        return GetTransactionModel.fromJson(json);
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

  Future<TransactionPostData> createTransaction(
      {required String leadId,
      required String date,
      required String transactionId,
      required String amount}) async {
    var url = Uri.parse(
        "https://sales.ghlindia.com/api/sales-person/lead/create-transactions");
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    };

    var request = http.MultipartRequest('POST', url);
    request.fields['lead_id'] = leadId;
    request.fields['date'] = date;
    request.fields['txn_id'] = transactionId;
    request.fields['amount'] = amount;
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {

        String responseBody = await response.stream.bytesToString();

        Map<String, dynamic> json = jsonDecode(responseBody);
        return TransactionPostData.fromJson(json);
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
