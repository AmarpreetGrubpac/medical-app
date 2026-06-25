class ProfileModel {
  bool? success;
  int? code;
  Profile? data;

  ProfileModel({this.success, this.code, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    data = json['data'] != null ? new Profile.fromJson(json['data']) : null;
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
  String? email;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? mobileNumber;
  String? employeeId;
  String? role;
  String? joiningDate;
  String? profilePic;

  Profile(
      {this.email,
      this.firstName,
      this.lastName,
      this.countryCode,
      this.mobileNumber,
      this.employeeId,
      this.role,
      this.profilePic,
      this.joiningDate});

  Profile.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    countryCode = json['country_code'];
    mobileNumber = json['mobile_number'];
    employeeId = json['employee_id'];
    role = json['role'];
    joiningDate = json['joining_date'];
    profilePic = json['profile_pic'];
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
    return data;
  }
}
