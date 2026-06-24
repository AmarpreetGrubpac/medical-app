class ConfigModel {
  bool? success;
  int? code;
  Data? data;

  ConfigModel({this.success, this.code, this.data});

  ConfigModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  Config? config;

  Data({this.config});

  Data.fromJson(Map<String, dynamic> json) {
    config =
    json['config'] != null ? new Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.config != null) {
      data['config'] = this.config!.toJson();
    }
    return data;
  }
}

class Config {
  String? minAndroidVersion;
  String? minIosVersion;
  String? androidLinks;
  String? iosLinks;
  String? maintenanceMode;
  String? imageUrls;
  String? privacyPolicyR;
  String? termsNConditionsR;

  Config(
      {this.minAndroidVersion,
        this.minIosVersion,
        this.androidLinks,
        this.iosLinks,
        this.maintenanceMode,
        this.privacyPolicyR,
        this.termsNConditionsR,
        this.imageUrls});

  Config.fromJson(Map<String, dynamic> json) {
    minAndroidVersion = json['minAndroidVersion'];
    minIosVersion = json['minIosVersion'];
    androidLinks = json['androidLinks'];
    iosLinks = json['iosLinks'];
    maintenanceMode = json['maintenanceMode'];
    imageUrls = json['imageUrls'];
    privacyPolicyR = json['privacyPolicyLink'];
    termsNConditionsR = json['termsAndConditionsLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minAndroidVersion'] = this.minAndroidVersion;
    data['minIosVersion'] = this.minIosVersion;
    data['androidLinks'] = this.androidLinks;
    data['iosLinks'] = this.iosLinks;
    data['maintenanceMode'] = this.maintenanceMode;
    data['imageUrls'] = this.imageUrls;
    data['privacyPolicyLink'] = this.privacyPolicyR;
    data['termsAndConditionsLink'] = this.termsNConditionsR;
    return data;
  }
}
