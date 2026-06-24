import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class EditIconButton extends StatefulWidget {
  const EditIconButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<EditIconButton> createState() => _EditIconButtonState();
}

class _EditIconButtonState extends State<EditIconButton> {
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
  void didUpdateWidget(EditIconButton oldWidget) {
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
                iconColor: AppTheme.contentBrandDefault,
                shadowColor: AppTheme.contentBrandDefault.withValues(alpha: 0.4),
              );

            case ButtonState.disabled:
              return _button();
          }
        },
      ),
    );
  }

  Widget _button({Color? buttonColor, Color? borderColor, Color? shadowColor, Color? iconColor}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: shadowColor != null
            ? [BoxShadow(offset: Offset(0, 0), color: shadowColor, blurRadius: 0, spreadRadius: 4)]
            : [],
      ),
      child: Container(
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: buttonColor ?? AppTheme.background,
          border: Border.all(color: borderColor ?? AppTheme.contentBrandDefault),
        ),
        child: Center(
          child: SvgPicture.asset(
            IconAsset.edit,
            height: 20.h,
            width: 20.h,
            colorFilter: ColorFilter.mode(iconColor ?? AppTheme.contentNeutralLight, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
