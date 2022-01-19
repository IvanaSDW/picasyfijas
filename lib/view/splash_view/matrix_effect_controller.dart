import 'dart:async';
import 'dart:math';

import 'package:bulls_n_cows_reloaded/view/splash_view/vertical_text_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MatrixEffectController extends GetxController {
  late Timer timer;
  final List<Widget> verticalLines = <Widget>[].obs;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (verticalLines.length <= 60) {
        verticalLines.add(_getVerticalTextLine());
      }
    });
  }

  Widget _getVerticalTextLine() {
    Key key = GlobalKey();
    return Positioned(
      key: key,
      left: Random().nextDouble() * Get.size.width,
      child: VerticalTextLine(
          onFinished: () {
            verticalLines.removeWhere((element) {
              return element.key == key;
            });
          },
          speed: 1 + Random().nextDouble() * 20,
          maxLength: Random().nextInt(10) + 5),
    );
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

}