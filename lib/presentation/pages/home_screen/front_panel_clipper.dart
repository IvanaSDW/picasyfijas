import 'package:flutter/cupertino.dart';

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