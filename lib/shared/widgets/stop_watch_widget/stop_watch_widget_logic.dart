import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatchWidgetLogic extends GetxController {

  final StopWatchTimer _timer = StopWatchTimer();
  StopWatchTimer get timer => _timer;
  
  void startTimer() {
    timer.onExecute.add(StopWatchExecute.start);
  }

  void stopTimer() {
    timer.onExecute.add(StopWatchExecute.stop);
  }

  String getDisplayTime(int elapsedTime) {
    return elapsedTime < 3600000 ?
    StopWatchTimer.getDisplayTime(elapsedTime, hours: false, milliSecond: false) :
    StopWatchTimer.getDisplayTime(elapsedTime, hours: true, milliSecond: true);
  }

  String convertToDisplayTime(int rawTime) {
    return StopWatchTimer.getDisplayTime(rawTime, hours: false, milliSecond: false);
  }
}
