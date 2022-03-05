import 'package:bulls_n_cows_reloaded/presentation/widgets/stop_watch_widget/chronometer_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/chronometer.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme.dart';

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
        builder: (context, snap) {
          return Row(
            children: <Widget>[
              Text(
                timerController.getDisplayTime(snap.data as int),
                style: TextStyle(
                  color: timerController.timer.mode == ChronometerMode.countUp
                  ? originalColors.textColorLight
                  : snap.data! as int > 60000
                      ? originalColors.textColorLight
                      : originalColors.accentColor1,
                  fontSize: snap.data! as int < 3600000 ? 35 : 25,
                  fontFamily: 'SFDigitalHeavyObliq',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
