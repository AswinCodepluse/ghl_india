class TimeLineModel {
  List<Data>? data;
  bool? success;
  int? status;

  TimeLineModel({this.data, this.success, this.status});

  TimeLineModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? user;
  String? oldStatus;
  String? newStatus;
  String? notes;
  String? file;
  String? nextFollowUpDate;
  String? createdAt;

  Data(
      {this.id,
        this.user,
        this.oldStatus,
        this.newStatus,
        this.notes,
        this.file,
        this.nextFollowUpDate,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    oldStatus = json['old_status'];
    newStatus = json['new_status'];
    notes = json['notes'];
    file = json['file'];
    nextFollowUpDate = json['next_follow_up_date'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['old_status'] = this.oldStatus;
    data['new_status'] = this.newStatus;
    data['notes'] = this.notes;
    data['file'] = this.file;
    data['next_follow_up_date'] = this.nextFollowUpDate;
    data['created_at'] = this.createdAt;
    return data;
  }
}