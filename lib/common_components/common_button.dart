import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class CommonButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final String? icon;
  final bool isDisabled, isLoading;
  final double? iconSize, fontSize, height;
  final EdgeInsets? padding;

  const CommonButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isDisabled = false,
    this.isLoading = false,
    this.icon,
    this.iconSize,
    this.fontSize,
    this.padding,
    this.height,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  final ValueNotifier<ButtonState> _stateNotifier =
      ValueNotifier(ButtonState.defaultState);
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);

  Future<void> _handleTap() async {
    if (_isProcessing.value || widget.isDisabled || widget.isLoading) return;
    _isProcessing.value = true;

    _stateNotifier.value = ButtonState.pressed;
    await Future.delayed(const Duration(milliseconds: 100));

    widget.onPressed();
    await Future.delayed(const Duration(milliseconds: 100));

    _stateNotifier.value = ButtonState.defaultState;
    _isProcessing.value = false;
  }

  @override
  void initState() {
    super.initState();
    _stateNotifier.value =
        widget.isDisabled ? ButtonState.disabled : ButtonState.defaultState;
  }

  @override
  void didUpdateWidget(CommonButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDisabled) {
      _stateNotifier.value = ButtonState.disabled;
    } else if (!_isProcessing.value) {
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
        if (!widget.isDisabled && !widget.isLoading) {
          _handleTap();
        }
      },
      onLongPressStart: (_) {
        if (!widget.isDisabled && !widget.isLoading) {
          _stateNotifier.value = ButtonState.pressed;
        }
      },
      onLongPressEnd: (_) {
        if (!widget.isDisabled && !widget.isLoading) {
          _stateNotifier.value = ButtonState.defaultState;
        }
      },
      onLongPress: () {
        if (!widget.isDisabled && !widget.isLoading) {
          _stateNotifier.value = ButtonState.pressed;
        }
      },
      child: ValueListenableBuilder<ButtonState>(
        valueListenable: _stateNotifier,
        builder: (context, state, _) {
          switch (state) {
            case ButtonState.defaultState:
              return _button(
                  buttonColor: AppTheme.primary,
                  borderColor: AppTheme.contentBrandPrimary);

            case ButtonState.active:
              return _button(
                  buttonColor: AppTheme.primary,
                  borderColor: AppTheme.contentBrandPrimary);

            case ButtonState.pressed:
              return _button(
                buttonColor: AppTheme.pressedPrimaryButton,
                borderColor: AppTheme.pressedPrimaryButtonBorder,
                shadowColor: AppTheme.primary.withValues(alpha: 0.4),
                needUnderline: false,
              );

            case ButtonState.disabled:
              return _button(
                buttonColor: AppTheme.brandPrimaryButtonDisabled,
                borderColor: AppTheme.strokeInteractiveBrandDisabled,
                textColor: AppTheme.contentBrandDisabled,
              );
          }
        },
      ),
    );
  }

  Widget _button({
    required Color buttonColor,
    required Color borderColor,
    Color? shadowColor,
    Color? textColor,
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
      child: Container(
        height: widget.height ?? (widget.padding != null ? null : 56.h),
        width: widget.padding != null ? null : double.maxFinite,
        padding: widget.padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: buttonColor,
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 25.h,
                  height: 25.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5.w,
                      color: textColor ?? AppTheme.contentOnPrimary,
                    ),
                  ),
                )
              : Row(
                  spacing: 12.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null)
                      SvgPicture.asset(
                        widget.icon ?? "",
                        height: widget.iconSize ?? 32.h,
                        width: widget.iconSize ?? 32.h,
                      ),
                    AppText(
                      text: widget.title,
                      fontSize: widget.fontSize ?? 20.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? AppTheme.contentOnPrimary,
                      textDecoration: needUnderline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
