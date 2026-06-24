import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/custom_image.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class CommonMenuBox extends StatefulWidget {
  CommonMenuBox({
    super.key,
    required this.title,
    required this.icon,
    this.image,
    required this.onTap,
    this.isProfile = false,
  });

  final String title, icon;
  final String? image; // ✅ make nullable

  final VoidCallback onTap;
  final bool isProfile;

  @override
  State<CommonMenuBox> createState() => _CommonMenuBoxState();
}

class _CommonMenuBoxState extends State<CommonMenuBox> {
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
  void didUpdateWidget(CommonMenuBox oldWidget) {
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
          padding: EdgeInsetsGeometry.fromLTRB(16.w, 16.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: state == ButtonState.pressed
                ? AppTheme.strokeInteractiveBrandDisabled
                : AppTheme.background,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppTheme.strokeInteractiveBrandDisabled),
          ),
          child: Row(
            spacing: 12.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.h,
                children: [
                  widget.image != null && widget.image!.isNotEmpty
                      ? Container(
                          height: 32.h,
                          width: 32.h,
                          decoration: widget.isProfile
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: state == ButtonState.defaultState
                                      ? AppTheme.contentBrandSecondaryOrange
                                      : AppTheme.primary,
                                )
                              : null,
                          child: ClipRRect(
                            borderRadius: widget.isProfile
                                ? BorderRadius.circular(
                                    100.r) // 🔥 circular if profile
                                : BorderRadius.circular(6.r),
                            child:
                                // Image.network(
                                //   widget.image!,
                                //   color: widget.isProfile ? null :state == ButtonState.defaultState
                                //         ? AppTheme.contentBrandSecondaryOrange
                                //         : AppTheme.primary,
                                //   fit: BoxFit.cover,
                                //   height: 32.h,
                                //   width: 32.h,
                                //   errorBuilder: (context, error, stackTrace) {
                                //     return Center(
                                //       child: AppText(
                                //         text: widget.icon ?? "",
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.white,
                                //       ),
                                //     );
                                //   },
                                // ),
                                CustomImage(
                              image: widget.image!,
                              color:
                              widget.isProfile
                                  ? null
                                  :
                              state == ButtonState.defaultState
                                      ? AppTheme.contentBrandSecondaryOrange
                                      : AppTheme.primary,
                              fit: BoxFit.cover,
                              height: 32.h,
                              width: 32.h,
                            ),
                          ),
                        )
                      : (widget.icon != null && widget.icon!.isNotEmpty)
                          ? SvgPicture.asset(
                              widget.icon,
                              height: 32.h,
                              width: 32.h,
                              colorFilter: ColorFilter.mode(
                                state == ButtonState.defaultState
                                    ? AppTheme.contentBrandSecondaryOrange
                                    : AppTheme.primary,
                                BlendMode.srcIn,
                              ),
                            )
                          : SizedBox(
                              height: 32.h,
                              width: 32.h,
                            ),
                  AppText(
                    text: widget.title,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentNeutralPrimary,
                  ),
                ],
              ),
              SvgPicture.asset(
                IconAsset.arrowRight,
                height: 32.h,
                width: 32.h,
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
