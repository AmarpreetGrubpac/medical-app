import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';

class GlowSemiCirclePainters extends CustomPainter {
  final bool isVertical;
  final double top;

  GlowSemiCirclePainters({this.isVertical = false, this.top = 0}); // default - horizontal

  @override
  void paint(Canvas canvas, Size size) {
    if (isVertical) {
      canvas.save();
      canvas.translate(0, size.height - top);
      canvas.rotate(-math.pi / 2);
    }

    final center = Offset(size.width / 2, size.height / 1.2);
    final radius = size.width * 0.6;

    final glowPaint =
        Paint()
          ..shader = RadialGradient(
            radius: 1,
            colors: [const Color(0xffeff1f0).withValues(alpha: .55), const Color.fromARGB(0, 88, 190, 134)],
            stops: const [0, .85],
          ).createShader(Rect.fromCircle(center: center, radius: radius * 0.90));

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * 1.9), math.pi, math.pi, false, glowPaint);

    // Solid semi-circle (filled)
    final semiCirclePaint = Paint()..color = AppTheme.background;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi, math.pi, true, semiCirclePaint);

    if (isVertical) {
      canvas.restore(); // Restore original orientation
    }
  }

  @override
  bool shouldRepaint(covariant GlowSemiCirclePainters oldDelegate) {
    return oldDelegate.isVertical != isVertical;
  }
}
