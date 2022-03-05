import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../shared/constants.dart';
import '../../../shared/utils.dart';


class VolumeWidgetController extends GetxController {

  final GlobalKey trackKey = GlobalKey();
  final GlobalKey thumbKey = GlobalKey();
  Rx<double?> thumbX = 0.0.obs;

  final RxDouble _thumbWidth = 0.0.obs;
  set thumbWidth(double value) => _thumbWidth.value = value;
  double get thumbWidth => _thumbWidth.value;

  final RxDouble _trackWidth = 0.0.obs;
  set trackWidth(double value) => _trackWidth.value = value;
  double get trackWidth => _trackWidth.value;

  final RxDouble _maxThumbX = 0.0.obs;
  set maxThumbX(double value) => _maxThumbX.value = value;
  double get maxThumbX => _maxThumbX.value;

  final RxDouble _minThumbX = 0.0.obs;
  set minThumbX(double value) => _minThumbX.value = value;
  double get minThumbX => _minThumbX.value;

  final RxDouble _volInterval = 0.0.obs;
  set volInterval(double value) => _volInterval.value = value;
  double get volInterval => _volInterval.value;

  void onVolumeDragStart(DragStartDetails details) {
    // HapticFeedback.lightImpact();
    refreshVolumeRenderInfo();
  }

  void onVolumeDragging(DragUpdateDetails details) {
    logger.i('called');
    double newDx = thumbX.value! + details.primaryDelta!;
    if (minThumbX <= newDx && newDx <= maxThumbX && appController.backPanelOn) {
      thumbX.value = newDx;
      appController.volumeLevel = (thumbX.value! - minThumbX) / volInterval;
      logger.i('thumb position: ${thumbX.value}, Volume: ${appController.volumeLevel}');
    }
  }
  void onVolumeDragEnd(DragEndDetails details) {
    logger.i('called');
    // HapticFeedback.lightImpact();
  }

  void refreshVolumeRenderInfo() {
    thumbWidth = getRect(thumbKey).size.width;
    trackWidth = getRect(trackKey).size.width;
    maxThumbX = 0;
    minThumbX = -thumbWidth*0.72;
    volInterval = maxThumbX - minThumbX;
    logger.i('Thumb width: $thumbWidth, Track width: $trackWidth');
  }

}