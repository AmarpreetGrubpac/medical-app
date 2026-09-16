import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/model/profile_model.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_repo.dart';

class ProfileDetailsController extends GetxController {
  final ProfileRepo profileRepo;
  ProfileDetailsController({required this.profileRepo});

  Profile? _profiledata;
  Profile? get profileData => _profiledata;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int selectedForEdit = 0;
  String user_id = "";
  String name = "";
  String firstname = "";
  String email = "";
  String phone = "";
  String countryCode = "";
  String id = "";
  String role = "";
  String image = AppConstants.custmImageuRl;

  // String? image;
  String location = "da Pizza Corner, Delhi";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? createdDate;

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    if (profileRepo.apiClient.hasToken) {
      getProfileData();
    }
  }

  Future<void> getProfileData() async {
    isLoading = true;
    update();
    // name = "Amarpreet Singh";
    // email = "amarkounsal@gmail.com";
    // phone = "1234567890";
    // countryCode = "+91";
    // id = "1234567890";
    // role = "driver";
    // createdDate = DateTime.now();
    // image = AppConstants.custmImageuRl;

    Response response = await profileRepo.getProfileData();

    if (response.statusCode == 200) {
      _profiledata = ProfileModel.fromJson(response.body).data;

      name = '${_profiledata?.firstName ?? ""} ${_profiledata?.lastName ?? ""}';
      firstname = _profiledata?.firstName ?? "";
      email = _profiledata?.email ?? "";
      user_id = _profiledata?.id ?? "";
      // email = "shoyabkhan13012001@gmail.com";

      phone = _profiledata?.mobileNumber ?? "";
      countryCode = _profiledata?.countryCode ?? "";
      id = _profiledata?.employeeId ?? "";
      role = _profiledata?.role ?? "";
      createdDate = _profiledata?.joiningDate;
      image = _profiledata?.profilePic ?? AppConstants.custmImageuRl;
      // image = _profiledata?.profilePic;
    }

    isLoading = false;
    update();
  }

  void onChangePassTap() => Navigation.pushNamed(RouteHelper.changePass);
  void onDeleteAcTap() => Navigation.pushNamed(RouteHelper.deleteAc);
  void onEditTap(int value) {
    selectedForEdit = value;

    if (value == 1) {
      nameController.text = name;
    } else if (value == 2) {
      emailController.text = email;
    } else if (value == 3) {
      phoneController.text = phone;
    }

    update();
  }

  Future<void> onSaveTap() async {
    if (formKey.currentState?.validate() ?? false) {
      if (selectedForEdit == 1) {
        name = nameController.text.trim();
      } else if (selectedForEdit == 2) {
        email = emailController.text.trim();
      } else if (selectedForEdit == 3) {
        phone = phoneController.text.trim();
      }

      selectedForEdit = 0;
      update();
    }
  }

//   Future<void> updatePassword() async {
//     Map<String, dynamic> data = {
//       "old_password": oldPasswordController.text.trim(),
//       "new_password": newPasswordController.text.trim(),
//     };

//     Response res = await profileRepo.updatePassword(data);
//     if (res.statusCode == 200) {
//       Navigation.pop();
//       AppToast.showSuccess(message: AppString.setPasswordSuccessfully);
//     } else {
//       AppToast.showError(message: res.body['error'] ?? "Something Went Wrong");
//     }
//   }
}
