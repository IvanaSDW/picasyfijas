import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../shared/constants.dart';
import '../../shared/utils.dart';

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

  // void onSliderTapDown(DragDownDetails details) {
  //   refreshSliderRenderInfo();
  //   sliderDuration = 0;
  // }
  //
  // void onSliderTap() {
  //   refreshSliderRenderInfo();
  //   sliderDuration = 0;
  // }

  void onSliderDragStart(DragStartDetails details) {
    HapticFeedback.lightImpact();
    refreshSliderRenderInfo();
    sliderDuration = 0;
  }

  void onSliderDragging(DragUpdateDetails details) {
    logger.i('called');
    double newDx = sliderThumbX.value! + details.primaryDelta!;
    if (0 <= newDx && newDx <= sliderTrackWidth - sliderThumbWidth) {
      logger.i('moving slider thumb');
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
      logger.i('Thumb width: $sliderThumbWidth, Track width: $sliderTrackWidth');
    }

    // Offset getPosition(GlobalKey key) {
    //   final box = key.currentContext!.findRenderObject() as RenderBox;
    //   Offset position = box.localToGlobal(Offset.zero);
    //   return position;
    // }

    // void updateSliderFrontPosition() {
    //   Offset position = getPosition(sliderThumbKey);
    //   logger.i('before position is: X= ${position.dx}, Y= ${position.dy}');
    //   sliderThumbX.value = position.dx;
    //   logger.i('after position is: X= ${sliderThumbX.value}');
    // }
    //
    // void updateSliderFrontRect() {
    //   Rect rect = getRect(sliderThumbKey);
    //   logger.i('before rect position is: Left = ${rect.left}, Top= ${rect.top}');
    //   sliderThumbX.value = rect.left;
    //   logger.i('after position is: Left = ${sliderThumbX.value}');
    // }

  void toggleDrawer() {
    if (appController.drawerSlideValue == 0.0) {
      openDrawer();
    } else {
      closeDrawer();
    }
  }

  void openDrawer() {
    if (appController.drawerSlideValue < 1.0) {
      appController.playEffect('monitor_turn_on.mp3');
      appController.drawerSlideValue = 1.0;
      sliderDuration = 1500;
      sliderThumbX.value = sliderMaxThumbX;
    }
  }

  void closeDrawer() {
    logger.i('Called when drawerSlider value is: ${appController.drawerSlideValue}');
    if (appController.drawerSlideValue > 0.0) {
      appController.playEffect('monitor_turn_off.mp3');
      appController.drawerSlideValue = 0.0;
      sliderDuration = 1000;
      sliderThumbX.value = 0;
    }
  }
}