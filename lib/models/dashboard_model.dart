// class DashboardModel {
//   List<Data>? data;
//   bool? success;
//   int? status;
//
//   DashboardModel({this.data, this.success, this.status});
//
//   DashboardModel.fromJson(Map<String, dynamic> json) {
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
//   String? name;
//   int? count;
//
//   Data({this.id, this.name, this.count});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     count = json['count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['count'] = this.count;
//     return data;
//   }
// }

class DashboardModel {
  int? facebook;
  int? google;
  int? website;
  int? total;
  LeadStatus? leadStatus;

  DashboardModel(
      {this.facebook, this.google, this.website, this.total, this.leadStatus});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    google = json['google'];
    website = json['website'];
    total = json['total'];
    leadStatus = json['lead_status'] != null
        ? new LeadStatus.fromJson(json['lead_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['google'] = this.google;
    data['website'] = this.website;
    data['total'] = this.total;
    if (this.leadStatus != null) {
      data['lead_status'] = this.leadStatus!.toJson();
    }
    return data;
  }
}

class LeadStatus {
  List<Data>? data;

  LeadStatus({this.data});

  LeadStatus.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  int? count;

  Data({this.id, this.name, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}
