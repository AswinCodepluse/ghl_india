class RecordingFilesModel {
  List<RecordingFileData>? data;
  bool? success;
  int? status;

  RecordingFilesModel({this.data, this.success, this.status});

  RecordingFilesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RecordingFileData>[];
      json['data'].forEach((v) {
        data!.add(new RecordingFileData.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }
}

class RecordingFileData {
  int? id;
  String? name;
  String? dateTime;
  String? filePath;
  FileData? file;

  RecordingFileData(
      {this.id, this.name, this.dateTime, this.filePath, this.file});

  RecordingFileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dateTime = json['date_time'];
    filePath = json['file_path'];
    file = json['file'] != null ? new FileData.fromJson(json['file']) : null;
  }
}

class FileData {
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

  FileData(
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

  FileData.fromJson(Map<String, dynamic> json) {
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
}
