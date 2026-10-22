class ProfileModel {
  bool? success;
  int? code;
  Profile? data;

  ProfileModel({this.success, this.code, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json, [String? id]) {
    success = json['success'];
    code = json['code'];
    data = json['data'] != null ? new Profile.fromJson(json['data'], id) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Profile {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? mobileNumber;
  String? employeeId;
  String? role;
  String? joiningDate;
  String? profilePic;
  String? department;
  String? facility;

  Profile(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.countryCode,
      this.mobileNumber,
      this.employeeId,
      this.role,
      this.profilePic,
      this.joiningDate});

  Profile.fromJson(Map<String, dynamic> json, [String? id]) {
    this.id = id ?? json['id'] ?? json['user_id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    countryCode = json['country_code'];
    mobileNumber = json['mobile_number'];
    employeeId = json['employee_id'];
    role = json['role'];
    joiningDate = json['joining_date'];
    profilePic = json['profile_pic'];
    department = json['department'];
    facility = json['facility'] ?? json['organization_name'];
    // id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['country_code'] = this.countryCode;
    data['mobile_number'] = this.mobileNumber;
    data['employee_id'] = this.employeeId;
    data['role'] = this.role;
    data['joining_date'] = this.joiningDate;
    data['profile_pic'] = this.profilePic;
    data['department'] = department;
    data['facility'] = facility;
    return data;
  }
}
