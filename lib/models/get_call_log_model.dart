class GetCallLogModel {
  List<GetCallLogData>? data;
  bool? success;
  int? status;

  GetCallLogModel({this.data, this.success, this.status});

  GetCallLogModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetCallLogData>[];
      json['data'].forEach((v) {
        data!.add(new GetCallLogData.fromJson(v));
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

class GetCallLogData {
  int? id;
  String? name;
  String? startTime;
  String? endTime;
  int? duration;
  String? type;
  String? filePath;
  CallLogFile? file;

  GetCallLogData(
      {this.id,
      this.name,
      this.startTime,
      this.endTime,
      this.duration,
      this.type,
      this.filePath,
      this.file});

  GetCallLogData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    type = json['type'];
    filePath = json['file_path'];
    file = json['file'] != null ? new CallLogFile.fromJson(json['file']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['type'] = this.type;
    data['file_path'] = this.filePath;
    if (this.file != null) {
      data['file'] = this.file!.toJson();
    }
    return data;
  }
}

class CallLogFile {
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

  CallLogFile(
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

  CallLogFile.fromJson(Map<String, dynamic> json) {
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
