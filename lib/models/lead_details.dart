class LeadDetails {
  int? id;
  String? name;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String? email;
  String? phoneNo;
  String? status;
  String? source;
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
  String? lastUpdatedDate;

  LeadDetails(
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
        this.lastUpdatedDate});

  LeadDetails.fromJson(Map<String, dynamic> json) {
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
    data['last_updated_date'] = this.lastUpdatedDate;
    return data;
  }
}




// class LeadDetails {
//   int? id;
//   String? name;
//   String? address;
//   String? city;
//   String? state;
//   String? pincode;
//   String? email;
//   String? phoneNo;
//   String? status;
//   String? source;
//   String? assigned;
//   int? campaignId;
//   String? medium;
//   String? category;
//   String? createdDate;
//   String? userId;
//   String? planning;
//   String? sendMsg;
//   String? occupation;
//   String? incomebracket;
//   String? taxsaving;
//   String? utmTerm;
//   String? utmContent;
//   String? ip;
//
//   LeadDetails(
//       {this.id,
//         this.name,
//         this.address,
//         this.city,
//         this.state,
//         this.pincode,
//         this.email,
//         this.phoneNo,
//         this.status,
//         this.source,
//         this.assigned,
//         this.campaignId,
//         this.medium,
//         this.category,
//         this.createdDate,
//         this.userId,
//         this.planning,
//         this.sendMsg,
//         this.occupation,
//         this.incomebracket,
//         this.taxsaving,
//         this.utmTerm,
//         this.utmContent,
//         this.ip});
//
//   LeadDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     address = json['address'];
//     city = json['city'];
//     state = json['state'];
//     pincode = json['pincode'];
//     email = json['email'];
//     phoneNo = json['phone_no'];
//     status = json['status'];
//     source = json['source'];
//     assigned = json['assigned'];
//     campaignId = json['campaign_id'] ?? 0;
//     medium = json['medium'];
//     category = json['category'] ?? "";
//     createdDate = json['created_date'];
//     userId = json['user_id'] ?? "";
//     planning = json['planning'];
//     sendMsg = json['send_msg'];
//     occupation = json['occupation'];
//     incomebracket = json['incomebracket'];
//     taxsaving = json['taxsaving'];
//     utmTerm = json['utm_term'];
//     utmContent = json['utm_content'];
//     ip = json['ip'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['address'] = this.address;
//     data['city'] = this.city;
//     data['state'] = this.state;
//     data['pincode'] = this.pincode;
//     data['email'] = this.email;
//     data['phone_no'] = this.phoneNo;
//     data['status'] = this.status;
//     data['source'] = this.source;
//     data['assigned'] = this.assigned;
//     data['campaign_id'] = this.campaignId;
//     data['medium'] = this.medium;
//     data['category'] = this.category;
//     data['created_date'] = this.createdDate;
//     data['user_id'] = this.userId;
//     data['planning'] = this.planning;
//     data['send_msg'] = this.sendMsg;
//     data['occupation'] = this.occupation;
//     data['incomebracket'] = this.incomebracket;
//     data['taxsaving'] = this.taxsaving;
//     data['utm_term'] = this.utmTerm;
//     data['utm_content'] = this.utmContent;
//     data['ip'] = this.ip;
//     return data;
//   }
// }