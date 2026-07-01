import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/model/alert_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AlertBox extends StatefulWidget {
  const AlertBox({
    super.key,
    required this.data,
    required this.onTap,
    required this.onDismiss,
  });

  final AlertModel data;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  final ValueNotifier<ButtonState> _stateNotifier =
      ValueNotifier(ButtonState.defaultState);
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);

  Future<void> _handleTap() async {
    if (_isProcessing.value) return;
    _isProcessing.value = true;

    _stateNotifier.value = ButtonState.pressed;
    await Future.delayed(const Duration(milliseconds: 100));

    widget.onTap();
    await Future.delayed(const Duration(milliseconds: 100));

    _stateNotifier.value = ButtonState.defaultState;
    _isProcessing.value = false;
  }

  @override
  void didUpdateWidget(AlertBox oldWidget) {
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
      child: ValueListenableBuilder(
        valueListenable: _stateNotifier,
        builder: (context, state, _) => Container(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
          decoration: BoxDecoration(
            color: state == ButtonState.pressed
                ? AppTheme.strokeInteractiveBrandDisabled
                : AppTheme.background,
            border: Border(
                top:
                    BorderSide(color: AppTheme.strokeInteractiveBrandDisabled)),
          ),
          child: Column(
            spacing: 12.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 12.w,
                children: [
                  SvgPicture.asset(
                    widget.data.type == AlertType.success
                        ? IconAsset.checkCircle
                        : IconAsset.toastError,
                    height: 32.h,
                    width: 32.h,
                    colorFilter: ColorFilter.mode(
                      widget.data.type == AlertType.warning
                          ? AppTheme.contentBrandPrimaryYellow
                          : widget.data.type == AlertType.error
                              ? AppTheme.contentBrandPrimary
                              : AppTheme.contentBrandPrimaryGreen,
                      BlendMode.srcIn,
                    ),
                  ),
                  AppText(text: widget.data.title, fontWeight: FontWeight.w600),
                ],
              ),
              AppText(
                  text: widget.data.description,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: getAlertDateTime(widget.data.createdAt),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.contentBrandDefault,
                  ),
                  InkWell(
                    onTap: widget.onDismiss,
                    child: AppText(
                      text: AppString.dismiss,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.contentBrandPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getAlertDateTime(DateTime time) {
  final String day = DateFormat("EEEE").format(time);
  final String dtime = DateFormat("h:mm a").format(time);
  return "$dtime | $day";
}
