import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;
  final double dotSize;
  final double spacing;
  final double selectedDotSize;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
    this.dotSize = 8,
    this.spacing = 8,
    this.selectedDotSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: selectedDotSize,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            width: isActive ? selectedDotSize : dotSize,
            height: isActive ? selectedDotSize : dotSize,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.backgroundBrandSecondary : AppTheme.backgroundNeutralSecondary,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
