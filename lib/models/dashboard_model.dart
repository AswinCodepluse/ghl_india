class DashboardModel {
  int? total;
  int? facebook;
  int? google;
  int? website;
  int? whatsapp;
  int? dp;
  int? ai;
  List<LeadStatus>? leadStatus;

  DashboardModel(
      {this.total, this.facebook, this.google, this.website,this.whatsapp,this.dp,this.ai, this.leadStatus});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    facebook = json['facebook'];
    google = json['google'];
    website = json['website'];
    whatsapp = json['whatsapp'];
    dp = json['dp'];
    ai = json['ai_chat'];
    if (json['lead_status'] != null) {
      leadStatus = <LeadStatus>[];
      json['lead_status'].forEach((v) {
        leadStatus!.add(new LeadStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['facebook'] = this.facebook;
    data['google'] = this.google;
    data['website'] = this.website;
    data['whatsapp'] = this.whatsapp;
    data['dp'] = this.dp;
    data['ai_chat'] = this.ai;
    if (this.leadStatus != null) {
      data['lead_status'] = this.leadStatus!.map((v) => v.toJson()).toList();
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
