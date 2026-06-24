import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';

class NumberedPoint extends StatelessWidget {
  const NumberedPoint({super.key, required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 20.w, child: AppText(text: number, fontWeight: FontWeight.w400)),
        Expanded(child: AppText(text: text, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
