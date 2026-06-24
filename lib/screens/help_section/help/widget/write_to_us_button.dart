import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class WriteToUsButton extends StatefulWidget {
  final VoidCallback onPressed;

  const WriteToUsButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<WriteToUsButton> createState() => _WriteToUsButtonState();
}

class _WriteToUsButtonState extends State<WriteToUsButton> {
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
  void didUpdateWidget(WriteToUsButton oldWidget) {
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
              return _button(borderColor: AppTheme.contentBrandDefault);

            case ButtonState.active:
              return _button(borderColor: AppTheme.contentBrandDefault);

            case ButtonState.pressed:
              return _button(
                buttonColor: AppTheme.pressedTextBtnColor,
                borderColor: AppTheme.contentBrandDefault,
                shadowColor: AppTheme.contentBrandDefault.withValues(alpha: 0.4),
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
          height: 40.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: buttonColor ?? AppTheme.background,
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: Row(
              spacing: 12.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  IconAsset.penLine,
                  height: 20.h,
                  width: 20.h,
                  colorFilter: ColorFilter.mode(AppTheme.contentBrandDefault, BlendMode.srcIn),
                ),
                AppText(
                  text: AppString.writeToUs,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppTheme.contentBrandDefault,
                  textDecoration: needUnderline ? TextDecoration.underline : TextDecoration.none,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
