import 'dart:async';
import 'dart:math';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/vertical_text_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MatrixEffectController extends GetxController {
  late Timer timer;
  final RxList<Widget> verticalLines = <Widget>[].obs;
  final List<Color>? colors;
  final int? speedMillis;
  double greenStart = 0.3;
  final List<String> _characters = [];
  double fontSize = Random().nextInt(12)+8.toDouble();
  List<double> stops = [];

  MatrixEffectController({this.speedMillis, this.colors});


  void startTimer() {
    timer = Timer.periodic(
        Duration(milliseconds: speedMillis ?? 200), //Speed
            (timer) {
          if (verticalLines.length <= 200) { //Density
            verticalLines.add(_getVerticalTextLine());
          }
        });

  }

  List<Widget> getCharacters(double fontSize) {
    List<Widget> textWidgets = [];
    for (var character in _characters) {
      textWidgets.add(
          Text(character,
              style: TextStyle(
                // fontFamily: "Monospace",
                  fontSize: fontSize))
      );
    }

    return textWidgets;
  }

  Widget _getVerticalTextLine() {
    Key key = GlobalKey();
    return Positioned(
      key: key,
      left: Random().nextDouble() * Get.size.width,
      child: VerticalTextLine(
          colors: colors,
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