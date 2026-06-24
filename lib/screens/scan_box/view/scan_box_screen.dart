import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/scan_box/controller/scan_box_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBoxScreen extends StatelessWidget {
  ScanBoxScreen({super.key});

  final ScanBoxController scanBoxController = Get.put(ScanBoxController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanBoxController>(
      builder: (controller) {
        final screenSize = MediaQuery.of(context).size;
        final scanBoxSize = 294.h;
        final verticalOffset = 60.0;

        // Calculate consistent top and left positions
        final scanBoxTop = (screenSize.height - scanBoxSize) / 2 - verticalOffset;
        final scanBoxLeft = (screenSize.width - scanBoxSize) / 2;

        final scanRect = Rect.fromLTWH(scanBoxLeft, scanBoxTop, scanBoxSize, scanBoxSize);

        return Scaffold(
          body: Stack(
            children: [
              // 👁 Camera view
              MobileScanner(controller: controller.scannerController, onDetect: controller.onDetect),

              // 🔲 Blur mask outside scan box
              Positioned.fill(child: CustomPaint(painter: _ScanOverlayPainter(scanRect: scanRect))),

              // ⬜️ Scan box border aligned exactly with scanRect
              Positioned(
                top: scanBoxTop,
                left: scanBoxLeft,
                child: Container(
                  width: scanBoxSize,
                  height: scanBoxSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primary, width: 4),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),

              // 🔙 Back Button
              Positioned(top: 24.h, left: 24.w, child: SafeArea(child: CommonBackButton())),

              // SCAN & INFO
              Positioned(
                bottom: 48.h,
                left: 24.w,
                right: 24.w,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 36.h,
                    children: [
                      // 🔘 Manual Scan Button
                      CommonButton(
                        onPressed: controller.onManualScan,
                        isLoading: controller.isLoading,
                        title: AppString.scanText,
                      ),

                      // 📄 Bottom Info Text
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppTheme.background,
                          border: Border.all(color: AppTheme.contentBrandDisabled),
                        ),
                        child: AppText(
                          text: AppString.pointCamera,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.commonColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  final Rect scanRect;

  _ScanOverlayPainter({required this.scanRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withAlpha(140)
          ..style = PaintingStyle.fill;

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRRect(RRect.fromRectXY(scanRect, 8.r, 8.r)),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
