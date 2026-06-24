import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

import '../core/theme/app_theme.dart';

class CommonTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final bool isDisabled, isLoading;
  final EdgeInsets? padding;
  final double? fontSize, height;

  const CommonTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isDisabled = false,
    this.isLoading = false,
    this.padding,
    this.fontSize,
    this.height,
  });

  @override
  State<CommonTextButton> createState() => _CommonTextButtonState();
}

class _CommonTextButtonState extends State<CommonTextButton> {
  final ValueNotifier<ButtonState> _stateNotifier = ValueNotifier(ButtonState.defaultState);
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
    _stateNotifier.value = widget.isDisabled ? ButtonState.disabled : ButtonState.defaultState;
  }

  @override
  void didUpdateWidget(CommonTextButton oldWidget) {
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
              return _button();

            case ButtonState.active:
              return _button();

            case ButtonState.pressed:
              return _button(
                buttonColor: AppTheme.pressedTextBtnColor,
                textColor: AppTheme.pressedTextBtnText,
                shadowColor: AppTheme.pressedTextBtnText.withValues(alpha: 0.4),
                needUnderline: true,
              );

            case ButtonState.disabled:
              return _button(buttonColor: AppTheme.disabledTextButton, textColor: AppTheme.disabledTextColor);
          }
        },
      ),
    );
  }

  Widget _button({Color? buttonColor, Color? shadowColor, Color? textColor, bool needUnderline = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow:
            shadowColor != null
                ? [BoxShadow(offset: Offset(0, 0), color: shadowColor, blurRadius: 0, spreadRadius: 2)]
                : [],
      ),
      child: IntrinsicWidth(
        child: Container(
          height: widget.height ?? (widget.padding != null ? null : 40.h),
          width: widget.padding != null ? null : double.maxFinite,
          padding: widget.padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: buttonColor ?? Colors.transparent,
          ),
          child: Center(
            child: AppText(
              text: widget.title,
              fontSize: widget.fontSize ?? 16.sp,
              fontWeight: FontWeight.w500,
              color: textColor ?? AppTheme.contentBrandDefault,
              textDecoration: needUnderline ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

///===============
class CommonCompactTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final String? icon;
  final double? fontSize, iconSize;
  final bool isDisabled, isLoading;

  const CommonCompactTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isDisabled = false,
    this.isLoading = false,
    this.icon,
    this.fontSize,
    this.iconSize,
  });

  @override
  State<CommonCompactTextButton> createState() => _CommonCompactTextButtonState();
}

class _CommonCompactTextButtonState extends State<CommonCompactTextButton> {
  final ValueNotifier<ButtonState> _stateNotifier = ValueNotifier(ButtonState.defaultState);
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
    _stateNotifier.value = widget.isDisabled ? ButtonState.disabled : ButtonState.defaultState;
  }

  @override
  void didUpdateWidget(CommonCompactTextButton oldWidget) {
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
              return _button();

            case ButtonState.active:
              return _button();

            case ButtonState.pressed:
              return _button(
                buttonColor: AppTheme.pressedTextBtnColor,
                textColor: AppTheme.pressedTextBtnText,
                needUnderline: true,
              );

            case ButtonState.disabled:
              return _button(textColor: AppTheme.contentBrandDisabled);
          }
        },
      ),
    );
  }

  Widget _button({Color? buttonColor, Color? textColor, bool needUnderline = false}) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: buttonColor ?? Colors.transparent,
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8.w,
            children: [
              AppText(
                text: widget.title,
                fontSize: widget.fontSize,
                color: textColor ?? AppTheme.contentBrandDefault,
                textDecoration: needUnderline ? TextDecoration.underline : TextDecoration.none,
              ),
              if (widget.icon != null)
                SvgPicture.asset(
                  widget.icon ?? "",
                  height: widget.iconSize ?? 32.h,
                  width: widget.iconSize ?? 32.h,
                  colorFilter: ColorFilter.mode(AppTheme.contentBrandDefault, BlendMode.srcIn),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
