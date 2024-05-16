class AttachmentModel {
  List<AttachmentData>? data;
  bool? success;
  int? status;

  AttachmentModel({this.data, this.success, this.status});

  AttachmentModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AttachmentData>[];
      json['data'].forEach((v) {
        data!.add(new AttachmentData.fromJson(v));
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

class AttachmentData {
  int? id;
  String? name;
  String? file;

  AttachmentData({this.id, this.name, this.file});

  AttachmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['file'] = this.file;
    return data;
  }
}