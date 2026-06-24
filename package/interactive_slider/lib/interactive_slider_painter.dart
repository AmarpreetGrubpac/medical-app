import 'package:flutter/material.dart';
import 'package:interactive_slider/interactive_slider.dart';

class InteractiveSliderPainter extends CustomPainter {
  InteractiveSliderPainter({
    required this.progress,
    required Color color,
    this.gradient,
    required this.gradientSize,
    this.numberOfSegments,
    required this.segmentDividerColor,
    required this.segmentDividerWidth,
    required this.thumbRadius,
    required this.thumbColor,
    required this.thumbBorder,
  })  : _rectPaint = Paint()..color = color,
        super(repaint: progress);

  final ValueNotifier<double> progress;
  final Gradient? gradient;
  final GradientSize gradientSize;
  final int? numberOfSegments;
  final Color segmentDividerColor;
  final double segmentDividerWidth;
  final Paint _rectPaint;

  final double thumbRadius;
  final Color thumbColor;
  final Color thumbBorder;

  @override
  void paint(Canvas canvas, Size size) {
    final progressWidth = progress.value * size.width;
    final progressRect = Rect.fromLTWH(0, 0, progressWidth, size.height);
    final borderRadius = Radius.circular(size.height / 2); // Adjust as needed

    // Create a rounded rectangle (RRect)
    final rrect = RRect.fromRectAndRadius(progressRect, borderRadius);

    if (gradient != null) {
      final sizeRect = gradientSize == GradientSize.totalWidth
          ? Rect.fromLTWH(0, 0, size.width, size.height)
          : progressRect;
      _rectPaint.shader = gradient!.createShader(sizeRect);
    }

    if (numberOfSegments != null) {
      final segmentWidth = size.width / numberOfSegments!;
      final segmentProgressWidth = (progress.value * numberOfSegments!).round() * segmentWidth;
      final segmentRect = Rect.fromLTWH(0, 0, segmentProgressWidth, size.height);
      final segmentRRect = RRect.fromRectAndRadius(segmentRect, borderRadius);
      canvas.drawRRect(segmentRRect, _rectPaint);

      final dividerPaint = Paint()
        ..color = segmentDividerColor
        ..strokeWidth = segmentDividerWidth
        ..style = PaintingStyle.stroke;

      for (var segment = 1; segment < numberOfSegments!; segment++) {
        final position = segmentWidth * segment;
        canvas.drawLine(Offset(position, 0), Offset(position, size.height), dividerPaint);
      }
    } else {
      canvas.drawRRect(rrect, _rectPaint);
    }

    final thumbCenter = Offset(progress.value * size.width, size.height / 2);

    const double borderWidth = 2.0; // You can parameterize this if needed
    final borderPaint = Paint()
      ..color = thumbBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawCircle(thumbCenter, thumbRadius + (borderWidth / 2), borderPaint);

    // Draw thumb on top
    final thumbPaint = Paint()..color = thumbColor;
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(InteractiveSliderPainter oldDelegate) =>
      progress.value != oldDelegate.progress.value || _rectPaint.color != oldDelegate._rectPaint.color;
}
