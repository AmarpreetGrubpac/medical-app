import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/common_components/custom_loader.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/widgets/details_row.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/widgets/edit_icon_button.dart';
import 'package:grubpac_driver/common_components/role_gated.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileDetailsController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CommonAppNameBar(),
              CommonBackAppBar(
                title: AppString.yourProfile,
                trailing: OwnerOnly(
                  child: EditIconButton(
                    onTap: controller.onChangePassTap,
                  ),
                ),
              ),
              Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: AppTheme.strokeInteractiveBrandDisabled),
              Expanded(
                child: controller.isLoading
                    ? CustomLoader(
                        colorcircular: true,
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                        child: Form(
                          key: controller.formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60.h,
                                backgroundColor: AppTheme.contentBrandSecondary,
                                child: ClipOval(
                                    child: controller.image.isEmpty
                                        ? AppText(
                                            text: AppUtils.getInitials(
                                                controller.name),
                                            fontSize: 28.sp)
                                        : Image.network(controller.image,
                                            width: 120.h,
                                            height: 120.h,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                AppText(
                                                    text: AppUtils.getInitials(
                                                        controller.name),
                                                    fontSize: 28.sp))),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.h),
                                child: Column(
                                  spacing: 8.h,
                                  children: [
                                    AppText(
                                      text: controller.name,
                                      textAlign: TextAlign.center,
                                      fontSize: 24.sp,
                                      color: AppTheme.contentNeutralPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    AppText(
                                      text: "#${controller.id}",
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                spacing: 16.h,
                                children: [
                                  // DetailsRow(
                                  //   icon: IconAsset.mail,
                                  //   title: AppString.email,
                                  //   value: controller.email,
                                  // ),
                                  DetailsRow(
                                    icon: IconAsset.mail,
                                    title: AppString.email,
                                    value: controller.email.length > 20
                                        ? '${controller.email}'
                                        : controller.email,
                                  ),

                                  DetailsRow(
                                    icon: IconAsset.phone,
                                    title: AppString.contact,
                                    value:
                                        "${controller.countryCode} ${controller.phone}",
                                  ),
                                  DetailsRow(
                                      icon: IconAsset.key,
                                      title: AppString.password,
                                      value: "********"),
                                ],
                              ),
                              Divider(
                                height: 49.h,
                                thickness: 1.h,
                                color: AppTheme.strokeInteractiveBrandDisabled,
                              ),
                              Column(
                                spacing: 16.h,
                                children: [
                                  DetailsRow(
                                    icon: IconAsset.user,
                                    title: "Department",
                                    value: controller.department,
                                  ),
                                  DetailsRow(
                                    icon: IconAsset.locationPin,
                                    title: "Facility",
                                    value: controller.location,
                                    maxlines: 3,
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 48.h, bottom: 24.h),
                                child: CommonTextButton(
                                  onPressed: controller.onDeleteAcTap,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 10.h),
                                  fontSize: 16.sp,
                                  title: AppString.deleteAcBtn,
                                ),
                              ),
                              AppText(
                                text:
                                    "${AppString.acCreated}\t${controller.createdDate}", //DateFormat("d MMMM yyyy").format(controller.createdDate)
                                fontSize: 14.sp,
                                color: AppTheme.contentNeutralLight,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
