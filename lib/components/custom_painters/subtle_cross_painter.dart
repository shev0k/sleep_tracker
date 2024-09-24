// lib/components/custom_painters/subtle_cross_painter.dart

import 'package:flutter/material.dart';

class SubtleCrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(115, 255, 255, 255)
      ..strokeWidth = 2.2 
      ..strokeCap = StrokeCap.round;

    final padding = size.width * 0.20;

    canvas.drawLine(
        Offset(padding, padding),
        Offset(size.width - padding, size.height - padding),
        paint);
    canvas.drawLine(
        Offset(size.width - padding, padding),
        Offset(padding, size.height - padding),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
