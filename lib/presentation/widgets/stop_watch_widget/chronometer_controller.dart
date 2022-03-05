import 'package:bulls_n_cows_reloaded/shared/chronometer.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';

class ChronometerController extends GetxController {

  final ChronometerMode mode;
  final int? countDownPresetMillis;
  late final Chronometer _timer;
  Chronometer get timer => _timer;

  ChronometerController({required this.mode, this.countDownPresetMillis})
      : assert ((mode == ChronometerMode.countDown && countDownPresetMillis != null)
      || (mode == ChronometerMode.countUp || countDownPresetMillis == null));

  void startTimer() {
    timer.onExecute.add(ChronometerExecute.start);
  }

  void stopTimer() {
    timer.onExecute.add(ChronometerExecute.stop);
  }

  void restartFromNewPreset(int newPresetMillis) {
    timer.startFromNewPreset(newPresetMillis);
  }

  String getDisplayTime(int elapsedTime) {
    return elapsedTime < 3600000 ?
    Chronometer.getDisplayTime(elapsedTime, hours: false, milliSecond: false) :
    Chronometer.getDisplayTime(elapsedTime, hours: true, milliSecond: true);
  }

  String convertToDisplayTime(int rawTime) {
    return Chronometer.getDisplayTime(rawTime, hours: false, milliSecond: false);
  }

  @override
  void onInit() {
    logger.i('called');
    _timer = Chronometer(isLapHours: false,
        mode: mode,
        presetMillisecond: mode == ChronometerMode.countUp
            ? 0
            : countDownPresetMillis ?? Chronometer.getMilliSecFromMinute(5)
    );
    super.onInit();
  }
}
