import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/light_theme_colors.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

import '../core/theme/app_theme.dart';

class CommonOutlinedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final bool isDisabled, isLoading;
  final double? height, fontSize;
  final EdgeInsets? padding;
  final bool allowTapWhenDisabled;


  const CommonOutlinedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isDisabled = false,
    this.isLoading = false,
    this.allowTapWhenDisabled = false, // 👈 NEW

    this.height,
    this.fontSize,
    this.padding,
  });

  @override
  State<CommonOutlinedButton> createState() => _CommonOutlinedButtonState();
}

class _CommonOutlinedButtonState extends State<CommonOutlinedButton> {
  final ValueNotifier<ButtonState> _stateNotifier = ValueNotifier(ButtonState.defaultState);
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);

  // Future<void> _handleTap() async {
  //   if (_isProcessing.value || widget.isDisabled || widget.isLoading) return;
  //   _isProcessing.value = true;
  //
  //   _stateNotifier.value = ButtonState.pressed;
  //   await Future.delayed(const Duration(milliseconds: 100));
  //
  //   widget.onPressed();
  //   await Future.delayed(const Duration(milliseconds: 100));
  //
  //   _stateNotifier.value = ButtonState.defaultState;
  //   _isProcessing.value = false;
  // }
  Future<void> _handleTap() async {
    if (_isProcessing.value || widget.isLoading) return;

    if (widget.isDisabled && !widget.allowTapWhenDisabled) return;

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
    _stateNotifier.value = widget.isDisabled ? ButtonState.disabled : ButtonState.defaultState;
  }

  @override
  void didUpdateWidget(CommonOutlinedButton oldWidget) {
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
        //   if (!widget.isDisabled && !widget.isLoading) {
        //     _handleTap();
        //   }
        // },
        if (!widget.isLoading &&
            (!widget.isDisabled || widget.allowTapWhenDisabled)) {
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
              return _button(borderColor: LightThemeColors.contentBrandPrimaryOrange);

            case ButtonState.active:
              return _button(borderColor: LightThemeColors.contentBrandPrimaryOrange);

            case ButtonState.pressed:
              return _button(
                buttonColor: AppTheme.contentBrandSecondaryOrange,
                borderColor: LightThemeColors.contentBrandPrimaryOrange,
                shadowColor: AppTheme.primary.withValues(alpha: 0.4),
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
          height: widget.height ?? (widget.padding != null ? null : 56.h),
          width: widget.padding != null ? null : double.maxFinite,
          padding: widget.padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: buttonColor ?? AppTheme.background,
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
                        color: textColor ?? AppTheme.contentBrandPrimaryOrange,
                      ),
                    ),
                  )
                : AppText(
                    text: widget.title,
                    fontSize: widget.fontSize ?? 20.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? AppTheme.contentBrandPrimaryOrange,
                    textDecoration: needUnderline ? TextDecoration.underline : TextDecoration.none,
                  ),
          ),
        ),
      ),
    );
  }
}
