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
  int? oldStatusInt;
  String? oldStatus;
  String? newStatus;
  int? newStatusInt;
  String? notes;
  String? file;
  Type? type;
  String? callRecord;
  String? voiceRecord;
  String? nextFollowUpDate;
  String? nextFollowUpTime;
  String? createdAt;

  Data(
      {this.id,
        this.user,
        this.oldStatusInt,
        this.oldStatus,
        this.newStatus,
        this.newStatusInt,
        this.notes,
        this.file,
        this.type,
        this.callRecord,
        this.voiceRecord,
        this.nextFollowUpDate,
        this.nextFollowUpTime,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    oldStatusInt = json['old_status_int'];
    oldStatus = json['old_status'];
    newStatus = json['new_status'];
    newStatusInt = json['new_status_int'];
    notes = json['notes'];
    file = json['file'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
    callRecord = json['call_record'];
    voiceRecord = json['voice_record'];
    nextFollowUpDate = json['next_follow_up_date'];
    nextFollowUpTime = json['next_follow_up_time'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['old_status_int'] = this.oldStatusInt;
    data['old_status'] = this.oldStatus;
    data['new_status'] = this.newStatus;
    data['new_status_int'] = this.newStatusInt;
    data['notes'] = this.notes;
    data['file'] = this.file;
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    data['call_record'] = this.callRecord;
    data['voice_record'] = this.voiceRecord;
    data['next_follow_up_date'] = this.nextFollowUpDate;
    data['next_follow_up_time'] = this.nextFollowUpTime;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Type {
  int? id;
  String? fileOriginalName;
  String? fileName;
  int? userId;
  String? fileSize;
  String? extension;
  String? type;
  String? externalLink;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Type(
      {this.id,
        this.fileOriginalName,
        this.fileName,
        this.userId,
        this.fileSize,
        this.extension,
        this.type,
        this.externalLink,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileOriginalName = json['file_original_name'];
    fileName = json['file_name'];
    userId = json['user_id'];
    fileSize = json['file_size'];
    extension = json['extension'];
    type = json['type'];
    externalLink = json['external_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_original_name'] = this.fileOriginalName;
    data['file_name'] = this.fileName;
    data['user_id'] = this.userId;
    data['file_size'] = this.fileSize;
    data['extension'] = this.extension;
    data['type'] = this.type;
    data['external_link'] = this.externalLink;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}





// class TimeLineModel {
//   List<Data>? data;
//   bool? success;
//   int? status;
//
//   TimeLineModel({this.data, this.success, this.status});
//
//   TimeLineModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     success = json['success'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['success'] = this.success;
//     data['status'] = this.status;
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   String? user;
//   String? oldStatus;
//   String? newStatus;
//   String? notes;
//   String? file;
//   String? nextFollowUpDate;
//   String? nextFollowUpTime;
//   String? createdAt;
//
//   Data(
//       {this.id,
//       this.user,
//       this.oldStatus,
//       this.newStatus,
//       this.notes,
//       this.file,
//       this.nextFollowUpDate,
//       this.nextFollowUpTime,
//       this.createdAt});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     user = json['user'];
//     oldStatus = json['old_status'];
//     newStatus = json['new_status'];
//     notes = json['notes'];
//     file = json['file'];
//     nextFollowUpDate = json['next_follow_up_date'];
//     nextFollowUpTime = json['next_follow_up_time'];
//     createdAt = json['created_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user'] = this.user;
//     data['old_status'] = this.oldStatus;
//     data['new_status'] = this.newStatus;
//     data['notes'] = this.notes;
//     data['file'] = this.file;
//     data['next_follow_up_date'] = this.nextFollowUpDate;
//     data['next_follow_up_time'] = this.nextFollowUpTime;
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }
