

import 'package:flutter/cupertino.dart';

Rect getRect(GlobalKey key) {
  final box = key.currentContext!.findRenderObject() as RenderBox;
  return box.paintBounds;
}