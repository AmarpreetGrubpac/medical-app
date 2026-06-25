import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alerts_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  final AlertsController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String tempBox;
  late String tempDateRange;
  late String tempAlertSeverity;
  late String tempCategory;

  @override
  void initState() {
    super.initState();
    tempBox = widget.controller.selectedBox;
    tempDateRange = widget.controller.selectedDateRange;
    tempAlertSeverity = widget.controller.selectedAlertSeverity;
    tempCategory = widget.controller.selectedCategory;
  }

  void _resetLocalFilters() {
    setState(() {
      tempBox = "All";
      tempDateRange = "All";
      tempAlertSeverity = "All";
      tempCategory = "All";
    });
  }

  void _applyFilters() {
    widget.controller.applyFilters(
      box: tempBox,
      dateRange: tempDateRange,
      alertSeverity: tempAlertSeverity,
      category: tempCategory,
    );
    Navigation.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 36.h),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        border: Border(
          top: BorderSide(
            color: AppTheme.strokeInteractiveBrandDisabled,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            color: AppTheme.contentOnPrimary.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                AppText(
                  text: "Filters",
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.contentNeutralPrimary,
                ),
                const Spacer(),
                CommonCompactTextButton(
                  title: "Reset All",
                  onPressed: _resetLocalFilters,
                  fontSize: 16.sp,
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: () => Navigation.pop(),
                  child: SvgPicture.asset(
                    IconAsset.close,
                    height: 24.h,
                    width: 24.h,
                    colorFilter: ColorFilter.mode(
                      AppTheme.contentNeutralPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Scrollable filter groups
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Box group
                    _buildFilterGroup(
                      title: "BOX",
                      options: widget.controller.availableBoxes,
                      currentVal: tempBox,
                      onSelected: (val) => setState(() => tempBox = val),
                    ),

                    // Date range group
                    _buildFilterGroup(
                      title: "DATE",
                      options: const ["All", "Today", "Yesterday", "Last 7 Days"],
                      currentVal: tempDateRange,
                      onSelected: (val) => setState(() => tempDateRange = val),
                    ),

                    // Alert Severity group
                    _buildFilterGroup(
                      title: "ALERT",
                      options: const ["All", "Warning", "Error", "Success"],
                      currentVal: tempAlertSeverity,
                      onSelected: (val) => setState(() => tempAlertSeverity = val),
                    ),

                    // Category group
                    _buildFilterGroup(
                      title: "TYPE",
                      options: const ["All", "Camera", "Battery", "Lock", "Display", "Other"],
                      currentVal: tempCategory,
                      onSelected: (val) => setState(() => tempCategory = val),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Apply Button
            CommonButton(
              onPressed: _applyFilters,
              title: "APPLY FILTERS",
              fontSize: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterGroup({
    required String title,
    required List<String> options,
    required String currentVal,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.h,
      children: [
        AppText(
          text: title,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppTheme.contentBrandDefault,
        ),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((option) {
            final isSelected = option.toLowerCase() == currentVal.toLowerCase();
            return GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppTheme.strokeInteractiveBrandDisabled,
                    width: 1,
                  ),
                ),
                child: AppText(
                  text: option,
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppTheme.contentOnPrimary
                      : AppTheme.contentNeutralSecondary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
