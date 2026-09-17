import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class CommonBottomBox extends StatelessWidget {
  final String? title;
  final String? description;
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool isEmergency;

  const CommonBottomBox({
    super.key,
    this.title,
    this.description,
    this.buttonText,
    this.onPressed,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: isEmergency ? AppTheme.bgBrandSecondaryRed : AppTheme.backgroundBrandSecondaryYellow,
        border: Border.all(
          color: isEmergency ? AppTheme.strokeBrandPrimaryAlt : AppTheme.strokeBrandPrimaryYellow,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEmergency)
            SvgPicture.asset(
              IconAsset.toastError,
              height: 32.h,
              width: 32,
              colorFilter: ColorFilter.mode(AppTheme.strokeBrandPrimaryAlt, BlendMode.srcIn),
            ),
          AppText(text: title ?? "", fontWeight: FontWeight.w600, color: AppTheme.contentNeutralPrimary),
          AppText(
            text: description ?? "",
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.contentNeutralPrimary,
          ),
          IntrinsicWidth(
            child: isEmergency
                ? CallRestButton(
                    onPressed: onPressed!,
                    title: buttonText ?? "",
                  )
                : IntrinsicWidth(
                    child: GestureDetector(
                      onTap: onPressed,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppTheme.strokeBrandPrimaryYellow,
                          border: Border.all(color: AppTheme.contentBrandPrimaryYellow),
                        ),
                        child: AppText(
                          text: buttonText ?? "",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.contentOnPrimary,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CallRestButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;

  const CallRestButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  State<CallRestButton> createState() => _CallRestButtonState();
}

class _CallRestButtonState extends State<CallRestButton> {
  final ValueNotifier<ButtonState> _stateNotifier = ValueNotifier(ButtonState.defaultState);
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);

  Future<void> _handleTap() async {
    if (_isProcessing.value) return;
    _isProcessing.value = true;

    _stateNotifier.value = ButtonState.pressed;
    await Future.delayed(const Duration(milliseconds: 100));

    widget.onPressed();
    await Future.delayed(const Duration(milliseconds: 100));

    _stateNotifier.value = ButtonState.defaultState;
    _isProcessing.value = false;
  }

  @override
  void didUpdateWidget(CallRestButton oldWidget) {
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
              return _button(
                borderColor: AppTheme.strokeBrandPrimaryAlt,
                textColor: AppTheme.strokeBrandPrimaryAlt,
              );

            case ButtonState.active:
              return _button(
                borderColor: AppTheme.strokeBrandPrimaryAlt,
                textColor: AppTheme.strokeBrandPrimaryAlt,
              );

            case ButtonState.pressed:
              return _button(
                buttonColor: AppTheme.bgBrandSecondaryRed,
                borderColor: AppTheme.strokeBrandPrimaryAlt,
                textColor: AppTheme.strokeBrandPrimaryAlt,
                shadowColor: AppTheme.strokeBrandPrimaryAlt.withValues(alpha: 0.4),
                needUnderline: true,
              );

            case ButtonState.disabled:
              return _button(
                buttonColor: AppTheme.outlinedButtonDisabled,
                borderColor: AppTheme.strokeInteractiveBrandDisabled,
                textColor: AppTheme.contentBrandDisabled,
              );
          }
        },
      ),
    );
  }

  Widget _button({
    Color? buttonColor,
    required Color borderColor,
    Color? shadowColor,
    Color? textColor,
    bool needUnderline = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: shadowColor != null
            ? [BoxShadow(offset: Offset(0, 0), color: shadowColor, blurRadius: 0, spreadRadius: 4)]
            : [],
        color: shadowColor != null ? AppTheme.background : null,
      ),
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: buttonColor ?? AppTheme.background,
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: AppText(
              text: widget.title,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: textColor ?? AppTheme.strokeBrandPrimaryAlt,
              textDecoration: needUnderline ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
