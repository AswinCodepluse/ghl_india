class TransactionPostData {
  bool? result;
  Response? response;
  String? message;

  TransactionPostData({this.result, this.response, this.message});

  TransactionPostData.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Response {
  String? leadId;
  String? date;
  String? txnId;
  String? amount;
  String? updatedAt;
  String? createdAt;
  int? id;

  Response(
      {this.leadId,
      this.date,
      this.txnId,
      this.amount,
      this.updatedAt,
      this.createdAt,
      this.id});

  Response.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    date = json['date'];
    txnId = json['txn_id'];
    amount = json['amount'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lead_id'] = this.leadId;
    data['date'] = this.date;
    data['txn_id'] = this.txnId;
    data['amount'] = this.amount;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
