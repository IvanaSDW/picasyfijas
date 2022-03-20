import 'package:flutter/material.dart';

class AddAreaPainter extends CustomPainter {
  final double strokeWidth;

  AddAreaPainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    var paint = Paint();
    paint.isAntiAlias = true;
    paint.shader = const RadialGradient(
      radius: 2,
        colors: [
          Color(0xFF77E75D),
          Color(0xFF59A544),
          Color(0xFF70B428),
          Color(0xFF2C7D20),
          Color(0xFF29930F),
          Color(0xFF317931),
        ],
      center: Alignment.centerLeft,
    ).createShader(rect);
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = strokeWidth;
    var path = Path();
    path.moveTo(size.width*0.65, 0);
    path.arcToPoint(
        Offset(size.width*0.59, size.width*0.06),
        radius: Radius.circular(size.width*0.06),
        rotation: 45,
        clockwise: false);
    path.arcToPoint(
        Offset(size.width*0.5, size.height*0.31),
        radius: Radius.circular(size.width*0.08),
        rotation: 45,
        clockwise: true);
    path.lineTo(size.width*0.05, size.height*0.31);
    path.arcToPoint(
        Offset(size.width*0.01, size.height*0.4),
        radius: Radius.circular(size.width*0.04),
      clockwise:false,
    );
    path.lineTo(size.width*0.01, size.height*0.84);
    path.arcToPoint(
        Offset(size.width*0.06, size.height*0.97),
        radius: Radius.circular(size.width*0.05),
        rotation: 45,
        clockwise: false);
    path.lineTo(size.width*0.94, size.height*0.97);
    path.arcToPoint(
        Offset(size.width*0.99, size.height*0.84),
        radius: Radius.circular(size.width*0.05),
        rotation: 45,
        clockwise: false);
    path.lineTo(size.width * 0.99, size.width*0.06);
    path.arcToPoint(
        Offset(size.width* 0.94, 0),
        radius: Radius.circular(size.width*0.05),
        rotation: 45,
        clockwise: false);
    path.close();
    canvas.drawPath(path, paint);

  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
