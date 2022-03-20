
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class VerticalTextLine extends StatefulWidget {
  const VerticalTextLine({
    required this.onFinished,
    this.speed = 75.0,
    this.maxLength = 10,
    this.colors,
    Key? key,
  }) : super(key: key);

  final double speed;
  final int maxLength;
  final VoidCallback onFinished;
  final List<Color>? colors;

  @override
  _VerticalTextLineState createState() => _VerticalTextLineState(colors);
}


class _VerticalTextLineState extends State<VerticalTextLine> {
  late int _maxLength;
  late Duration _stepInterval;
  final List<String> _characters = [];
  List<int> charCodes = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 70, 80, 102, 112];
  late Timer timer;
  double fontSize = Random().nextInt(12)+8.toDouble();
  List<Color>? colors;


  _VerticalTextLineState(this.colors);

  @override
  void initState() {
    _maxLength = widget.maxLength;
    _stepInterval = Duration(milliseconds: (1000 ~/ widget.speed));
    colors ??= [Colors.transparent, Colors.green, Colors.green, Colors.white];
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    timer = Timer.periodic(_stepInterval, (timer) {
      final _random = Random();
      String element = String.fromCharCode(
          charCodes[_random.nextInt(charCodes.length)]
        // _random.nextInt(512)
      );

      final box = context.findRenderObject() as RenderBox;

      if (box.size.height > MediaQuery.of(context).size.height * 2) {
        widget.onFinished();
        return;
      }

      setState(() {
        _characters.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<double> stops = [];
    // List<Color> colors = [];

    double greenStart = 0.3;
    double whiteStart = (_characters.length - 1) / (_characters.length);

    greenStart = (_characters.length - _maxLength) / _characters.length;

    stops = [0, greenStart, whiteStart, whiteStart];

    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: stops,
            colors: colors!,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Container(
          color: Colors.green.withOpacity(0.4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _getCharacters(fontSize),
          ),
        )
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List<Widget> _getCharacters(double fontSize) {
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
}