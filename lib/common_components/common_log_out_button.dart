import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

import '../screens/auth/controller/existing_user_controller.dart';

class CommonLogOutButton extends StatefulWidget {
  const CommonLogOutButton({super.key, this.isSettings = false});

  final bool isSettings;

  @override
  State<CommonLogOutButton> createState() => _CommonLogOutButtonState();
}

class _CommonLogOutButtonState extends State<CommonLogOutButton> {
  final ValueNotifier<ButtonState> _stateNotifier =
      ValueNotifier(ButtonState.defaultState);
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);

  Future<void> _handleTap() async {
    if (_isProcessing.value) return;
    _isProcessing.value = true;

    _stateNotifier.value = ButtonState.pressed;
    await Future.delayed(const Duration(milliseconds: 100));

    Get.find<ExistingUserController>().logoutAccount();
    print("data clear");
    await Future.delayed(const Duration(milliseconds: 100));

    _stateNotifier.value = ButtonState.defaultState;
    _isProcessing.value = false;
  }

  @override
  void didUpdateWidget(CommonLogOutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isProcessing.value) {
      _stateNotifier.value = ButtonState.defaultState;
    }
  }

  @override
  void dispose() {
    _stateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _handleTap();
      },
      onLongPressStart: (_) {
        _stateNotifier.value = ButtonState.pressed;
      },
      onLongPressEnd: (_) {
        _stateNotifier.value = ButtonState.defaultState;
      },
      onLongPress: () {
        _stateNotifier.value = ButtonState.pressed;
      },
      child: ValueListenableBuilder<ButtonState>(
        valueListenable: _stateNotifier,
        builder: (context, state, _) {
          switch (state) {
            case ButtonState.defaultState:
              return _button();

            case ButtonState.active:
              return _button();

            case ButtonState.pressed:
              return _button(
                buttonColor: AppTheme.pressedTextBtnColor,
                shadowColor:
                    AppTheme.contentBrandDefault.withValues(alpha: 0.4),
                needUnderline: true,
              );

            case ButtonState.disabled:
              return _button();
          }
        },
      ),
    );
  }

  Widget _button({
    Color? buttonColor,
    Color? borderColor,
    Color? shadowColor,
    Color? iconColor,
    bool needUnderline = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: shadowColor != null
            ? [
                BoxShadow(
                    offset: Offset(0, 0),
                    color: shadowColor,
                    blurRadius: 0,
                    spreadRadius: 4)
              ]
            : [],
      ),
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            16.w,
            widget.isSettings ? 10.h : 12.h,
            16.w,
            widget.isSettings ? 10.h : 12.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: buttonColor ?? AppTheme.background,
            border:
                Border.all(color: borderColor ?? AppTheme.contentBrandDefault),
          ),
          child: Center(
            child: Row(
              spacing: 12.w,
              children: [
                SvgPicture.asset(
                  IconAsset.logout,
                  height: widget.isSettings ? 20.h : 24.h,
                  width: widget.isSettings ? 20.h : 24.h,
                  colorFilter: ColorFilter.mode(
                      iconColor ?? AppTheme.contentBrandDefault,
                      BlendMode.srcIn),
                ),
                AppText(
                  text: AppString.logOut,
                  fontSize: widget.isSettings ? 16.sp : 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.contentBrandDefault,
                  textDecoration: needUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
