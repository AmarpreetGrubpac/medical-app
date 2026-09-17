import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/grublock_box.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';

class GrubLockBottomSheet extends StatefulWidget {
  final bool isLocked;
  final Future<bool> Function() onConfirm;

  const GrubLockBottomSheet({
    super.key,
    required this.isLocked,
    required this.onConfirm,
  });

  static Future<bool?> show({
    required BuildContext context,
    required bool isLocked,
    required Future<bool> Function() onConfirm,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GrubLockBottomSheet(
        isLocked: isLocked,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<GrubLockBottomSheet> createState() => _GrubLockBottomSheetState();
}

class _GrubLockBottomSheetState extends State<GrubLockBottomSheet> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final success = await widget.onConfirm();
      if (mounted && success) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _isLoading ? null : () => Navigator.of(context).pop(false),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 36.h),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                border: Border(
                  top: BorderSide(
                    color: AppTheme.strokeInteractiveBrandDisabled,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GrubLockBox(isLocked: widget.isLocked),
                  24.h.verticalSpace,
                  AppText(
                    text: widget.isLocked
                        ? "Ready to unlock?"
                        : "Ready to lock?",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentNeutralPrimary,
                    textAlign: TextAlign.center,
                  ),
                  12.h.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AppText(
                      text: widget.isLocked
                          ? "The action will immediately unlock the box."
                          : "The action will immediately lock the box.",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.contentNeutralSecondary,
                      textAlign: TextAlign.center,
                      height: 1.4,
                    ),
                  ),
                  28.h.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.strokeBrandPrimaryAlt,
                        disabledBackgroundColor: AppTheme.strokeBrandPrimaryAlt
                            .withValues(alpha: 0.6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24.h,
                              width: 24.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : AppText(
                              text: widget.isLocked
                                  ? "EMERGENCY UNLOCK"
                                  : "LOCK BOX",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
