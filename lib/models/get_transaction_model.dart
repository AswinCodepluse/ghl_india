class GetTransactionModel {
  List<TransactionData>? data;
  bool? success;
  int? status;

  GetTransactionModel({this.data, this.success, this.status});

  GetTransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(new TransactionData.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }
}

class TransactionData {
  int? id;
  String? txnId;
  String? date;
  String? amount;
  String? createdAt;
  String? updatedAt;

  TransactionData(
      {this.id,
      this.txnId,
      this.date,
      this.amount,
      this.createdAt,
      this.updatedAt});

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    txnId = json['txn_id'];
    date = json['date'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['txn_id'] = this.txnId;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
