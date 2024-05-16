import 'dart:convert';

LeadDatasCreate leadDatasCreateResponseFromJson(String str) => LeadDatasCreate.fromJson(json.decode(str));

String leadDatasCreateResponseToJson(LeadDatasCreate data) => json.encode(data.toJson());

class LeadDatasCreate {
  bool? result;
  String? message;

  LeadDatasCreate({this.result, this.message});

  LeadDatasCreate.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    return data;
  }
}