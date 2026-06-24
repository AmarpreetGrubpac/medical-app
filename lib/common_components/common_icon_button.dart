import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class CommonIconButton extends StatefulWidget {
  const CommonIconButton({super.key, required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  State<CommonIconButton> createState() => _CommonIconButtonState();
}

class _CommonIconButtonState extends State<CommonIconButton> {
  final ValueNotifier<ButtonState> _stateNotifier = ValueNotifier(ButtonState.defaultState);
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
  void didUpdateWidget(CommonIconButton oldWidget) {
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
                shadowColor: AppTheme.pressedTextBtnText.withValues(alpha: 0.2),
              );

            case ButtonState.disabled:
              return _button();
          }
        },
      ),
    );
  }

  Widget _button({Color? buttonColor, Color? shadowColor, Color? iconColor}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: shadowColor != null
            ? [BoxShadow(offset: Offset(0, 0), color: shadowColor, blurRadius: 0, spreadRadius: 2)]
            : [],
      ),
      child: Container(
        height: 48.h,
        width: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: buttonColor ?? Colors.transparent,
        ),
        child: Center(
          child: SvgPicture.asset(
            widget.icon,
            height: 24.h,
            width: 24.h,
            colorFilter: ColorFilter.mode(iconColor ?? AppTheme.contentBrandDefault, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

///============
class CommonCompactIconButton extends StatefulWidget {
  const CommonCompactIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.size,
    this.iconColor,
    this.pressedIconColor,
    this.pressedBgColor,
  });

  final String icon;
  final double size;
  final VoidCallback onTap;
  final Color? iconColor, pressedIconColor, pressedBgColor;

  @override
  State<CommonCompactIconButton> createState() => _CommonCompactIconButtonState();
}

class _CommonCompactIconButtonState extends State<CommonCompactIconButton> {
  final ValueNotifier<ButtonState> _stateNotifier = ValueNotifier(ButtonState.defaultState);
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
  void didUpdateWidget(CommonCompactIconButton oldWidget) {
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
              return _button(iconColor: widget.iconColor);

            case ButtonState.active:
              return _button(iconColor: widget.iconColor);

            case ButtonState.pressed:
              return _button(
                buttonColor: widget.pressedBgColor ?? AppTheme.contentBrandSecondaryOrange,
                iconColor: widget.pressedIconColor ?? AppTheme.pressedIconColor,
              );

            case ButtonState.disabled:
              return _button(buttonColor: AppTheme.disabledTextButton, iconColor: AppTheme.disabledTextColor);
          }
        },
      ),
    );
  }

  Widget _button({Color? buttonColor, Color? iconColor}) {
    return Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: buttonColor ?? Colors.transparent,
      ),
      child: Center(
        child: SvgPicture.asset(
          widget.icon,
          height: widget.size,
          width: widget.size,
          colorFilter: ColorFilter.mode(iconColor ?? AppTheme.contentBrandPrimaryOrange, BlendMode.srcIn),
        ),
      ),
    );
  }
}
