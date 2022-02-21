import 'package:flutter/material.dart';

class FrontPanelPainter extends CustomPainter {
  final double width;

  FrontPanelPainter({required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    var paint = Paint();
    paint.isAntiAlias = true;
    paint.shader = const RadialGradient(
      radius: 1.5,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFF424242),
          Color(0xFF1F1F1F),
          Color(0xFF494949),
          Color(0xFF101010),
          Color(0xFF000000),
        ]
    ).createShader(rect);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = width;
    var path = Path();
    path.moveTo(size.height*0.03, 0);
    path.arcToPoint(
        Offset(0, size.height*0.03),
        radius: Radius.circular(size.height*0.03),
        rotation: 45,
        clockwise: false);
    path.lineTo(0, size.height*0.76);
    // path.lineTo(size.width*0.02, size.height*0.78);
    path.arcToPoint(
        Offset(size.height*0.02, size.height*0.78),
        radius: Radius.circular(size.height*0.02),
        rotation: 45,
        clockwise: false);
    path.lineTo(size.width*0.5, size.height*0.78);
    path.arcToPoint(
        Offset(size.width*0.5, size.height*0.84),
        radius: Radius.circular(size.height*0.03)
    );
    path.lineTo(size.height*0.02, size.height*0.84);
    path.arcToPoint(
        Offset(0, size.height*0.86),
        radius: Radius.circular(size.height*0.02),
        rotation: 45,
        clockwise: false);
    // path.lineTo(0, size.height);
    path.lineTo(0, size.height*0.97);
    path.arcToPoint(
        Offset(size.height*0.03, size.height),
        radius: Radius.circular(size.height*0.03),
        rotation: 45,
        clockwise: false);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);

  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class FrontPanelClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final path = Path();
    path.moveTo(size.height*0.03, 0);
    path.arcToPoint(
        Offset(0, size.height*0.03),
        radius: Radius.circular(size.height*0.03),
        rotation: 45,
        clockwise: false);
    path.lineTo(0, size.height*0.76);
    path.arcToPoint(
        Offset(size.height*0.02, size.height*0.78),
        radius: Radius.circular(size.height*0.02),
        rotation: 45,
        clockwise: false);
    path.lineTo(size.width*0.5, size.height*0.78);
    path.arcToPoint(
        Offset(size.width*0.5, size.height*0.84),
        radius: Radius.circular(size.height*0.03)
    );
    path.lineTo(size.height*0.02, size.height*0.84);
    path.arcToPoint(
        Offset(0, size.height*0.86),
        radius: Radius.circular(size.height*0.02),
        rotation: 45,
        clockwise: false);
    path.lineTo(0, size.height*0.97);
    path.arcToPoint(
        Offset(size.height*0.03, size.height),
        radius: Radius.circular(size.height*0.03),
        rotation: 45,
        clockwise: false);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return false;
  }

}