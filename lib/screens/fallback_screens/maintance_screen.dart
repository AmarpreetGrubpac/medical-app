import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

import '../../helper/navigation.dart' show Navigation;

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  int _secondsRemaining = 60;
  bool _isButtonEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _isButtonEnabled = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get buttonText {
    if (_isButtonEnabled) return AppString.tryAgainMAintance;
    return '${AppString.tryAgainMAintance} IN $_secondsRemaining s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,

      // ✅ Proper bottom fixed button area
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 35.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonOutlinedButton(
                  title: buttonText,
                  isDisabled: !_isButtonEnabled,
                  isLoading: false,
                  onPressed: () {
                    // Navigation.replace(
                    //   RouteHelper.updateScreen,
                    // );
                  }),
              18.h.verticalSpace,
              AppText(
                text: AppString.mainteanceTimerText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                color: AppTheme.contentNeutralSecondary,
              ),
            ],
          ),
        ),
      ),

      // ✅ Proper center body UI
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 0),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.06),

              Image.asset(
                ImageAsset.maintenanceImage,
                height: 220.h,
                width: 220.w,
                fit: BoxFit.contain,
              ),
              30.h.verticalSpace,
              AppText(
                text: AppString.maintenanceTitle,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                color: AppTheme.commonColor,
              ),
              16.h.verticalSpace,
              AppText(
                text: AppString.maintenanceDescription,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                color: AppTheme.contentNeutralSecondary,
              ),

              15.h.verticalSpace,
              Center(
                child: AppText(
                  text: AppString.mainteanceSubTitle,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  color: AppTheme.contentNeutralSecondary,
                ),
              ),
              36.h.verticalSpace,

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
