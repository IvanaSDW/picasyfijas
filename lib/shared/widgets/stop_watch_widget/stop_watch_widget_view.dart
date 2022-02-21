import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import 'stop_watch_widget_logic.dart';

class StopWatchWidget extends StatelessWidget {
  final StopWatchWidgetLogic logic = Get.put(StopWatchWidgetLogic());

  StopWatchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: StreamBuilder(
        stream: logic.timer.rawTime,
        initialData: 0,
        builder: (context, snap) {
          return Row(
            children: <Widget>[
              Text(
                logic.getDisplayTime(snap.data as int),
                style: TextStyle(
                  color: originalColors.accentColor1,
                  fontSize: snap.data! as int < 3600000 ? 45 : 35,
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
