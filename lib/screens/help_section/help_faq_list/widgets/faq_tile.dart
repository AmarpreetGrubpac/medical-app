import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controller/help_support_model.dart';

class FaqTile extends StatefulWidget {
  const FaqTile({
    super.key,
    required this.faq,
  });

  final Faq faq;
  // final String id;

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  final ValueNotifier<ButtonState> _stateNotifier =
      ValueNotifier(ButtonState.defaultState);
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);

  Future<void> _handleTap() async {
    if (_isProcessing.value) return;
    _isProcessing.value = true;

    _stateNotifier.value = ButtonState.pressed;
    await Future.delayed(const Duration(milliseconds: 100));

    // Navigation.pushNamed(RouteHelper.faqAnswer, arg: {"faq": widget.faq});
    Navigation.pushNamed(
      RouteHelper.faqAnswer,
      arg: {"faq": widget.faq},
    );

    await Future.delayed(const Duration(milliseconds: 100));

    _stateNotifier.value = ButtonState.defaultState;
    _isProcessing.value = false;
  }

  @override
  void didUpdateWidget(FaqTile oldWidget) {
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
          child: Row(
            spacing: 16.w,
            children: [
              SvgPicture.asset(
                IconAsset.questionBox,
                height: 32.h,
                width: 32.h,
                colorFilter: ColorFilter.mode(
                  state == ButtonState.defaultState
                      ? AppTheme.contentBrandSecondaryOrange
                      : AppTheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              Expanded(
                child: AppText(
                  // text: widget.faq,
                  text: widget.faq.question ?? "",

                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.contentNeutralPrimary,
                ),
              ),
              SvgPicture.asset(
                IconAsset.arrowRight,
                height: 28.h,
                width: 28.h,
                colorFilter: ColorFilter.mode(
                    AppTheme.contentBrandDefault, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
