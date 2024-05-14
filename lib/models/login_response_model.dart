import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
class LoginResponse {
  bool? result;
  String? message;
  String? accessToken;
  String? tokenType;
  DateTime? expiresAt;
  User? user;

  LoginResponse(
      {this.result,
        this.message,
        this.accessToken,
        this.tokenType,
        this.expiresAt,
        this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresAt= json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]);
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_at'] = this.expiresAt == null ? null : this.expiresAt!.toIso8601String();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? type;
  String? email;
  String? phone;
  String? name;
  String? lastName;
  String? gender;
  String? directManager;
  String? jobPosition;
  String? location;
  String? defaultLanguage;
  String? secondLanguage;
  String? thirdLanguage;
  String? department;
  String? designation;
  String? address;
  String? city;
  String? state;
  String? pincode;
  bool? emailVerified;

  User(
      {this.id,
        this.type,
        this.email,
        this.phone,
        this.name,
        this.lastName,
        this.gender,
        this.directManager,
        this.jobPosition,
        this.location,
        this.defaultLanguage,
        this.secondLanguage,
        this.thirdLanguage,
        this.department,
        this.designation,
        this.address,
        this.city,
        this.state,
        this.pincode,
        this.emailVerified});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    lastName = json['last_name'];
    gender = json['gender'];
    directManager = json['direct_manager'];
    jobPosition = json['job_position'];
    location = json['location'];
    defaultLanguage = json['default_language'];
    secondLanguage = json['second_language'];
    thirdLanguage = json['third_language'];
    department = json['department'];
    designation = json['designation'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    emailVerified = json['email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['direct_manager'] = this.directManager;
    data['job_position'] = this.jobPosition;
    data['location'] = this.location;
    data['default_language'] = this.defaultLanguage;
    data['second_language'] = this.secondLanguage;
    data['third_language'] = this.thirdLanguage;
    data['department'] = this.department;
    data['designation'] = this.designation;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['email_verified'] = this.emailVerified;
    return data;
  }
}
