import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../shared/theme.dart';

class RadarPainter extends CustomPainter{

  final double angle;
  final Paint _bgPaint = Paint()
  ..color = originalColors.textColor3!.withOpacity(0.5)
  ..strokeWidth = 1.0
  ..style = PaintingStyle.stroke;

  final Paint _paint = Paint()..style = PaintingStyle.fill;

  int circleCount = 3;

  RadarPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = min(size.width / 2, size.height / 2);

    canvas.drawLine(Offset(size.width / 2, size.height / 2 - radius),
        Offset(size.width / 2, size.height / 2 + radius), _bgPaint);
    canvas.drawLine(Offset(size.width / 2 - radius, size.height / 2),
        Offset(size.width / 2 + radius, size.height / 2), _bgPaint);

    for (var i = 1; i <= circleCount; ++i) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2),
          radius * i / circleCount, _bgPaint);
    }

    _paint.shader = ui.Gradient.sweep(
        Offset(size.width / 2, size.height / 2),
        [Colors.white.withOpacity(.01), Colors.greenAccent.withOpacity(.5)],
        [.0, 1.0],
        TileMode.clamp,
        .0,
        pi / 12);

    canvas.save();
    double r = sqrt(pow(size.width, 2) + pow(size.height, 2));
    double startAngle = atan(size.height / size.width);
    Point p0 = Point(r * cos(startAngle), r * sin(startAngle));
    Point px = Point(r * cos(angle + startAngle), r * sin(angle + startAngle));
    canvas.translate((p0.x - px.x) / 2, (p0.y - px.y) / 2);
    canvas.rotate(angle);

    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        0,
        pi / 12,
        true,
        _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}