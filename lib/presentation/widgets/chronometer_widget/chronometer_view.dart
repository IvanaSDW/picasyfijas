import 'package:bulls_n_cows_reloaded/shared/chronometer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../shared/theme.dart';
import 'chronometer_controller.dart';

class ChronometerWidget extends StatelessWidget {
  final ChronometerController timerController;

  const ChronometerWidget({Key? key, required this.timerController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: StreamBuilder(
        stream: timerController.timer.rawTime,
        // initialData: 0,
        builder: (context, AsyncSnapshot<int> snap) {
          return snap.connectionState == ConnectionState.waiting
              ? const SpinKitThreeBounce(color: Colors.white,)
          : Row(
            children: <Widget>[
              Text(
                timerController.getDisplayTime(snap.data!),
                style: TextStyle(
                  color: timerController.timer.mode == ChronometerMode.countUp
                  ? originalColors.textColorLight
                  : snap.data! > 60000
                      ? originalColors.textColorLight
                      : originalColors.accentColor1,
                  fontSize: snap.data! < 3600000 ? 35 : 25,
                  fontFamily: 'Readout',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
