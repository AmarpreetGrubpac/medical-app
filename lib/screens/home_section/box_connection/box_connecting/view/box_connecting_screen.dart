import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';

class BoxConnectingScreen extends StatefulWidget {
  const BoxConnectingScreen({super.key});

  @override
  State<BoxConnectingScreen> createState() => _BoxConnectingScreenState();
}

class _BoxConnectingScreenState extends State<BoxConnectingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await redirectToNext());
  }

  final String isFrom = Get.arguments?["is_from"] ?? "";

  /// REDIRECT TO NEXT
  Future<void> redirectToNext() async {
    final String boxId = Get.arguments?["box_id"] ?? "";
    final controller = Get.find<BoxManagementController>();

    final success = await controller.connectBox(boxId);

    if (success) {
      AppToast.showSuccess(message: AppString.bluetoothConnectSuccess);
      await Future.delayed(const Duration(seconds: 2));
      Navigation.doublePop();
    } else {
      Navigation.doublePop();
      Navigation.pushNamed( 
        RouteHelper.boxConnectionError,
        arg: {"is_from": isFrom},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft, child: CommonBackButton()),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 36.h, bottom: 48.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        IconAsset.boxScanning,
                        height: 200.h,
                        width: 200.h,
                        colorFilter: ColorFilter.mode(
                            AppTheme.contentNeutralLight, BlendMode.srcIn),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 36.h, bottom: 8.h),
                        child: AppText(
                          text: AppString.lookingFor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.contentNeutralPrimary,
                        ),
                      ),
                      AppText(
                        text: AppString.makeSure,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
