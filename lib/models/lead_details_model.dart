class LeadDetails {
  int? id;
  String? name;
  String? address;
  String? information;
  String? description;
  String? city;
  String? state;
  String? pincode;
  String? email;
  String? phoneNo;
  String? status;
  int? statusInt;
  String? source;
  String? interest;
  String? assigned;
  String? campaign;
  String? medium;
  String? incomebracket;
  String? ip;
  String? occupation;
  String? planning;
  String? sendMsg;
  String? taxsaving;
  String? utmContent;
  String? company;
  String? website;
  String? designation;
  String? createdDate;
  String? createdAt;
  String? lastUpdatedDate;

  LeadDetails(
      {this.id,
      this.name,
      this.address,
      this.information,
      this.description,
      this.city,
      this.state,
      this.pincode,
      this.email,
      this.phoneNo,
      this.status,
      this.statusInt,
      this.source,
      this.interest,
      this.assigned,
      this.campaign,
      this.medium,
      this.incomebracket,
      this.ip,
      this.occupation,
      this.planning,
      this.sendMsg,
      this.taxsaving,
      this.utmContent,
      this.company,
      this.website,
      this.designation,
      this.createdDate,
      this.createdAt,
      this.lastUpdatedDate});

  LeadDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    information = json['information'];
    description = json['description'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    email = json['email'];
    phoneNo = json['phone_no'];
    status = json['status'];
    statusInt = json['status_int'];
    source = json['source'];
    interest = json['interest'];
    assigned = json['assigned'];
    campaign = json['campaign'];
    medium = json['medium'];
    incomebracket = json['incomebracket'];
    ip = json['ip'];
    occupation = json['occupation'];
    planning = json['planning'];
    sendMsg = json['send_msg'];
    taxsaving = json['taxsaving'];
    utmContent = json['utm_content'];
    company = json['company'];
    website = json['website'];
    designation = json['designation'];
    createdDate = json['created_date'];
    createdAt = json['created_at'];
    lastUpdatedDate = json['last_updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['information'] = this.information;
    data['description'] = this.description;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['email'] = this.email;
    data['phone_no'] = this.phoneNo;
    data['status'] = this.status;
    data['status_int'] = this.statusInt;
    data['source'] = this.source;
    data['interest'] = this.interest;
    data['assigned'] = this.assigned;
    data['campaign'] = this.campaign;
    data['medium'] = this.medium;
    data['incomebracket'] = this.incomebracket;
    data['ip'] = this.ip;
    data['occupation'] = this.occupation;
    data['planning'] = this.planning;
    data['send_msg'] = this.sendMsg;
    data['taxsaving'] = this.taxsaving;
    data['utm_content'] = this.utmContent;
    data['company'] = this.company;
    data['website'] = this.website;
    data['designation'] = this.designation;
    data['created_date'] = this.createdDate;
    data['created_at'] = this.createdAt;
    data['last_updated_date'] = this.lastUpdatedDate;
    return data;
  }
}