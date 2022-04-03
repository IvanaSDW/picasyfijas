import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shared/constants.dart';
import '../../../shared/utils.dart';


class SliderSwitchController extends GetxController {

  final RxInt _sliderDuration = 5.obs;
  set sliderDuration(int value) => _sliderDuration.value = value;
  int get sliderDuration => _sliderDuration.value;

  final GlobalKey sliderTrackKey = GlobalKey();
  final GlobalKey sliderThumbKey = GlobalKey();
  Rx<double?> sliderThumbX = 0.0.obs;

  final RxDouble _sliderThumbWidth = 0.0.obs;
  set sliderThumbWidth(double value) => _sliderThumbWidth.value = value;
  double get sliderThumbWidth => _sliderThumbWidth.value;

  final RxDouble _sliderTrackWidth = 0.0.obs;
  set sliderTrackWidth(double value) => _sliderTrackWidth.value = value;
  double get sliderTrackWidth => _sliderTrackWidth.value;

  final RxDouble _sliderThresholdLeft = 0.0.obs;
  set sliderThresholdLeft(double value) => _sliderThresholdLeft.value = value;
  double get sliderThresholdLeft => _sliderThresholdLeft.value;

  final RxDouble _sliderThresholdRight = 0.0.obs;
  set sliderThresholdRight(double value) => _sliderThresholdRight.value = value;
  double get sliderThresholdRight => _sliderThresholdRight.value;

  final RxDouble _sliderMaxThumbX = 0.0.obs;
  set sliderMaxThumbX(double value) => _sliderMaxThumbX.value = value;
  double get sliderMaxThumbX => _sliderMaxThumbX.value;

  void onSliderDragStart(DragStartDetails details) {
    HapticFeedback.lightImpact();
    refreshSliderRenderInfo();
    sliderDuration = 0;
  }

  void onSliderDragging(DragUpdateDetails details) {
    double newDx = sliderThumbX.value! + details.primaryDelta!;
    if (0 <= newDx && newDx <= sliderTrackWidth - sliderThumbWidth) {
      sliderThumbX.value = newDx;
    }
  }
    void onSliderDragEnd(DragEndDetails details) {
      HapticFeedback.lightImpact();
      sliderDuration = 1000;
      if(sliderThumbX.value! <= sliderThresholdLeft) {
        sliderThumbX.value = 0;
        closeDrawer();
      } else {
        sliderThumbX.value = sliderMaxThumbX;
        openDrawer();
      }
    }

    void refreshSliderRenderInfo() {
      sliderThumbWidth = getRect(sliderThumbKey).size.width;
      sliderTrackWidth = getRect(sliderTrackKey).size.width;
      sliderThresholdLeft = (sliderTrackWidth - sliderThumbWidth) / 2;
      sliderThresholdRight = sliderTrackWidth - sliderThresholdLeft;
      sliderMaxThumbX = sliderTrackWidth - sliderThumbWidth;
    }

  void toggleDrawer() {
    if (appController.drawerSlideValue == 0.0) {
      openDrawer();
    } else {
      closeDrawer();
    }
  }

  void openDrawer() {
    if (appController.drawerSlideValue < 1.0) {
      appController.playEffect('audio/multi-plier-open.wav');
      appController.drawerSlideValue = 1.0;
      sliderDuration = 800;
      sliderThumbX.value = sliderMaxThumbX;
    }
  }

  void closeDrawer() {
    if (appController.drawerSlideValue > 0.0) {
      appController.playEffect('audio/multi-plier-close.wav');
      appController.drawerSlideValue = 0.0;
      sliderDuration = 800;
      sliderThumbX.value = 0;
    }
  }
}