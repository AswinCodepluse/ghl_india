class ReportResponse {
  bool? result;
  Response? response;
  String? message;

  ReportResponse({this.result, this.response, this.message});

  ReportResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Response {
  int? id;
  int? isCustomer;
  int? investAmount;
  String? investDate;
  String? investType;
  String? helloCrmLead;
  String? name;
  String? lastName;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String? email;
  String? phoneNo;
  int? status;
  String? information;
  String? description;
  String? source;
  String? interest;
  int? assignedTo;
  String? company;
  String? designation;
  String? website;
  String? campaign;
  String? medium;
  String? category;
  String? incomebracket;
  String? ip;
  String? occupation;
  String? planning;
  String? sendMsg;
  String? taxsaving;
  String? utmContent;
  String? utmTerm;
  String? dataOnGoogle;
  String? notes;
  String? custfields;
  int? approxIncome;
  String? assignedDate;
  String? nextFollowUpDate;
  int? isReported;
  String? reportedNotes;
  String? reportedDate;
  String? reportedAction;
  String? createdAt;
  String? updatedAt;

  Response(
      {this.id,
        this.isCustomer,
        this.investAmount,
        this.investDate,
        this.investType,
        this.helloCrmLead,
        this.name,
        this.lastName,
        this.address,
        this.city,
        this.state,
        this.pincode,
        this.email,
        this.phoneNo,
        this.status,
        this.information,
        this.description,
        this.source,
        this.interest,
        this.assignedTo,
        this.company,
        this.designation,
        this.website,
        this.campaign,
        this.medium,
        this.category,
        this.incomebracket,
        this.ip,
        this.occupation,
        this.planning,
        this.sendMsg,
        this.taxsaving,
        this.utmContent,
        this.utmTerm,
        this.dataOnGoogle,
        this.notes,
        this.custfields,
        this.approxIncome,
        this.assignedDate,
        this.nextFollowUpDate,
        this.isReported,
        this.reportedNotes,
        this.reportedDate,
        this.reportedAction,
        this.createdAt,
        this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isCustomer = json['is_customer'];
    investAmount = json['invest_amount'];
    investDate = json['invest_date'];
    investType = json['invest_type'];
    helloCrmLead = json['hello_crm_lead'];
    name = json['name'];
    lastName = json['last_name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    email = json['email'];
    phoneNo = json['phone_no'];
    status = json['status'];
    information = json['information'];
    description = json['description'];
    source = json['source'];
    interest = json['interest'];
    assignedTo = json['assigned_to'];
    company = json['company'];
    designation = json['designation'];
    website = json['website'];
    campaign = json['campaign'];
    medium = json['medium'];
    category = json['category'];
    incomebracket = json['incomebracket'];
    ip = json['ip'];
    occupation = json['occupation'];
    planning = json['planning'];
    sendMsg = json['send_msg'];
    taxsaving = json['taxsaving'];
    utmContent = json['utm_content'];
    utmTerm = json['utm_term'];
    dataOnGoogle = json['data_on_google'];
    notes = json['notes'];
    custfields = json['custfields'];
    approxIncome = json['approx_income'];
    assignedDate = json['assigned_date'];
    nextFollowUpDate = json['next_follow_up_date'];
    isReported = json['is_reported'];
    reportedNotes = json['reported_notes'];
    reportedDate = json['reported_date'];
    reportedAction = json['reported_action'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_customer'] = this.isCustomer;
    data['invest_amount'] = this.investAmount;
    data['invest_date'] = this.investDate;
    data['invest_type'] = this.investType;
    data['hello_crm_lead'] = this.helloCrmLead;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['email'] = this.email;
    data['phone_no'] = this.phoneNo;
    data['status'] = this.status;
    data['information'] = this.information;
    data['description'] = this.description;
    data['source'] = this.source;
    data['interest'] = this.interest;
    data['assigned_to'] = this.assignedTo;
    data['company'] = this.company;
    data['designation'] = this.designation;
    data['website'] = this.website;
    data['campaign'] = this.campaign;
    data['medium'] = this.medium;
    data['category'] = this.category;
    data['incomebracket'] = this.incomebracket;
    data['ip'] = this.ip;
    data['occupation'] = this.occupation;
    data['planning'] = this.planning;
    data['send_msg'] = this.sendMsg;
    data['taxsaving'] = this.taxsaving;
    data['utm_content'] = this.utmContent;
    data['utm_term'] = this.utmTerm;
    data['data_on_google'] = this.dataOnGoogle;
    data['notes'] = this.notes;
    data['custfields'] = this.custfields;
    data['approx_income'] = this.approxIncome;
    data['assigned_date'] = this.assignedDate;
    data['next_follow_up_date'] = this.nextFollowUpDate;
    data['is_reported'] = this.isReported;
    data['reported_notes'] = this.reportedNotes;
    data['reported_date'] = this.reportedDate;
    data['reported_action'] = this.reportedAction;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
