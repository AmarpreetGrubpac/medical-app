import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_switch.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class ZoneCard extends StatelessWidget {
  final String zoneName;
  final String targetTemp;
  final String achievedTemp;
  final String type;
  final bool isOn;
  final VoidCallback onToggle;

  const ZoneCard({
    super.key,
    required this.zoneName,
    required this.targetTemp,
    required this.achievedTemp,
    required this.isOn,
    required this.onToggle,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: ZoneBoxType.color(type),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: ZoneBoxType.border(type)),
      ),
      child: Column(
        spacing: 8.h,
        children: [
          Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: zoneName,
                color: ZoneBoxType.text(type),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              CommonSwitch(isOn: isOn, onToggle: onToggle, isGreen: false),
            ],
          ),
          Container(height: 1.h, color: ZoneBoxType.border(type)),
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    type == ZoneBoxType.disabled
                        ? AppText(
                          text: "-",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: ZoneBoxType.text(type),
                        )
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppText(
                              text: targetTemp,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: ZoneBoxType.text(type),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 3.h),
                              child: AppText(
                                text: "°C",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: ZoneBoxType.text(type),
                              ),
                            ),
                          ],
                        ),
                    AppText(
                      text: AppString.target,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: ZoneBoxType.text(type),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    type == ZoneBoxType.disabled
                        ? AppText(
                          text: "-",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: ZoneBoxType.text(type),
                        )
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppText(
                              text: achievedTemp,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: ZoneBoxType.text(type),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 3.h),
                              child: AppText(
                                text: "°C",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: ZoneBoxType.text(type),
                              ),
                            ),
                          ],
                        ),
                    AppText(
                      text: AppString.achieved,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: ZoneBoxType.text(type),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
