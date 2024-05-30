class DashBoardModel {
  int? total;
  int? facebook;
  int? google;
  int? website;
  int? whatsapp;
  int? dp;
  int? aiChat;
  List<LeadStatus>? leadStatus;
  List<FollowUpToday>? followUpToday;

  DashBoardModel(
      {this.total,
      this.facebook,
      this.google,
      this.website,
      this.whatsapp,
      this.dp,
      this.aiChat,
      this.leadStatus,
      this.followUpToday});

  DashBoardModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    facebook = json['facebook'];
    google = json['google'];
    website = json['website'];
    whatsapp = json['whatsapp'];
    dp = json['dp'];
    aiChat = json['ai_chat'];
    if (json['lead_status'] != null) {
      leadStatus = <LeadStatus>[];
      json['lead_status'].forEach((v) {
        leadStatus!.add(new LeadStatus.fromJson(v));
      });
    }
    if (json['follow_up_today'] != null) {
      followUpToday = <FollowUpToday>[];
      json['follow_up_today'].forEach((v) {
        followUpToday!.add(new FollowUpToday.fromJson(v));
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
    data['ai_chat'] = this.aiChat;
    if (this.leadStatus != null) {
      data['lead_status'] = this.leadStatus!.map((v) => v.toJson()).toList();
    }
    if (this.followUpToday != null) {
      data['follow_up_today'] =
          this.followUpToday!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadStatus {
  List<DashboardData>? data;

  LeadStatus({this.data});

  LeadStatus.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DashboardData>[];
      json['data'].forEach((v) {
        data!.add(new DashboardData.fromJson(v));
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

class FollowUpToday {
  List<DashboardData>? data;

  FollowUpToday({this.data});

  FollowUpToday.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DashboardData>[];
      json['data'].forEach((v) {
        data!.add(new DashboardData.fromJson(v));
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

class DashboardData {
  int? id;
  String? name;
  int? count;

  DashboardData({this.id, this.name, this.count});

  DashboardData.fromJson(Map<String, dynamic> json) {
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
