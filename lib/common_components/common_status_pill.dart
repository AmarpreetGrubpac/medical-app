import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class CommonStatusPill extends StatelessWidget {
  const CommonStatusPill({super.key, required this.title, required this.type});

  final String title, type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: StatusType.boxColor(type),
        border: Border.all(color: StatusType.color(type)),
      ),
      child: AppText(text: title, fontSize: 14.sp, color: StatusType.color(type), height: 1),
    );
  }
}
