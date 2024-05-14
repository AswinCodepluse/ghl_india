


class LeadsData {
  List<AllLeads>? data;
  bool? success;
  int? status;

  LeadsData({this.data, this.success, this.status});

  LeadsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllLeads>[];
      json['data'].forEach((v) {
        data!.add(new AllLeads.fromJson(v));
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

class AllLeads {
  int? id;
  String? name;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String? email;
  String? phoneNo;
  int? status;
  String? source;
  String? assigned;
  int? campaignId;
  String? medium;
  String? incomebracket;
  String? ip;
  String? occupation;
  String? planning;
  String? sendMsg;
  String? taxsaving;
  String? utmContent;
  String? createdDate;
  String? lastUpdatedDate;

  AllLeads(
      {this.id,
        this.name,
        this.address,
        this.city,
        this.state,
        this.pincode,
        this.email,
        this.phoneNo,
        this.status,
        this.source,
        this.assigned,
        this.campaignId,
        this.medium,
        this.incomebracket,
        this.ip,
        this.occupation,
        this.planning,
        this.sendMsg,
        this.taxsaving,
        this.utmContent,
        this.createdDate,
        this.lastUpdatedDate});

  AllLeads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    email = json['email'];
    phoneNo = json['phone_no'];
    status = json['status'];
    source = json['source'];
    assigned = json['assigned'];
    campaignId = json['campaign_id'];
    medium = json['medium'];
    incomebracket = json['incomebracket'];
    ip = json['ip'];
    occupation = json['occupation'];
    planning = json['planning'];
    sendMsg = json['send_msg'];
    taxsaving = json['taxsaving'];
    utmContent = json['utm_content'];
    createdDate = json['created_date'];
    lastUpdatedDate = json['last_updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['email'] = this.email;
    data['phone_no'] = this.phoneNo;
    data['status'] = this.status;
    data['source'] = this.source;
    data['assigned'] = this.assigned;
    data['campaign_id'] = this.campaignId;
    data['medium'] = this.medium;
    data['incomebracket'] = this.incomebracket;
    data['ip'] = this.ip;
    data['occupation'] = this.occupation;
    data['planning'] = this.planning;
    data['send_msg'] = this.sendMsg;
    data['taxsaving'] = this.taxsaving;
    data['utm_content'] = this.utmContent;
    data['created_date'] = this.createdDate;
    data['last_updated_date'] = this.lastUpdatedDate;
    return data;
  }
}
