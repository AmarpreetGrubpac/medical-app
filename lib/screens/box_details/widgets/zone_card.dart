import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_components/app_text.dart';
import '../../../common_components/common_switch.dart';
import '../../../core/utils/enums.dart';

class ZoneCard extends StatelessWidget {
  final String zoneName, targetTemp, achievedTemp, type;
  final bool isOn;
  final VoidCallback onToggle;
  const ZoneCard(
      {super.key,
      required this.zoneName,
      required this.targetTemp,
      required this.achievedTemp,
      required this.isOn,
      required this.onToggle,
      required this.type});

  Widget _reading(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                    type == ZoneBoxType.disabled ? '--' : '$value\u00b0C',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: ZoneBoxType.text(type)))),
            AppText(
                text: label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: ZoneBoxType.text(type)),
          ]);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            color: ZoneBoxType.color(type),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: ZoneBoxType.border(type))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Expanded(
                child: AppText(
                    text: zoneName,
                    color: ZoneBoxType.text(type),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600)),
            CommonSwitch(isOn: isOn, onToggle: onToggle, isGreen: false)
          ]),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Divider(height: 1, color: ZoneBoxType.border(type))),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _reading('Target', targetTemp)),
            const SizedBox(width: 8),
            Expanded(child: _reading('Achieved', achievedTemp)),
          ]),
        ]),
      );
}
