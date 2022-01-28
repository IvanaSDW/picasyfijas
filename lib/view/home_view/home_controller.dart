import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

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

  final RxInt _sliderDuration = 100.obs;
  set sliderDuration(int value) => _sliderDuration.value = value;
  int get sliderDuration => _sliderDuration.value;

  final panelWidth = Get.width * 0.60;
  final _backPanelOn = false.obs;
  set backPanelOn(bool value) => _backPanelOn.value = value;
  bool get backPanelOn => _backPanelOn.value;

  final _isMuted = false.obs;
  set isMuted(bool value) => _isMuted.value = value;
  bool get isMuted => _isMuted.value;

  final RxDouble _drawerSlideValue = 0.0.obs;
  set drawerSlideValue(value) => _drawerSlideValue.value = value;
  double get drawerSlideValue => _drawerSlideValue.value;

  void toggleDrawer() {
    if (drawerSlideValue == 0.0) {
      openDrawer();
    } else {
      closeDrawer();
    }
  }

  void openDrawer() {
    playEffect('monitor_turn_on.mp3');
    drawerSlideValue = 1.0;
    sliderDuration = 1500;
    sliderThumbX.value = sliderMaxThumbX;
  }

  void closeDrawer() {
    playEffect('monitor_turn_off.mp3');
    drawerSlideValue = 0.0;
    sliderDuration = 1000;
    sliderThumbX.value = 0;
  }

  void onAvatarTapped() {
    refreshSliderRenderInfo();
    toggleDrawer();
  }

  void togglePanelOnOff() async {
    if (backPanelOn) {
      playEffect('button-36.wav');
      backPanelOn = false;
    } else {
      playEffect('beep-21.wav');
      // playEffect('button-35.wav');
      backPanelOn = true;
    }
  }

  void toggleMuteOnOff() {
    if (isMuted) {
      isMuted = false;
    } else {
      isMuted = true;
    }
  }

  Future<AudioPlayer> playEffect(String fileName) async {
    AudioCache cache = AudioCache();
    return await cache.play(fileName);
  }

  void refreshSliderRenderInfo() {
    sliderThumbWidth = getRect(sliderThumbKey).size.width;
    sliderTrackWidth = getRect(sliderTrackKey).size.width;
    sliderThresholdLeft = (sliderTrackWidth - sliderThumbWidth) / 2;
    sliderThresholdRight = sliderTrackWidth - sliderThresholdLeft;
    sliderMaxThumbX = sliderTrackWidth - sliderThumbWidth;
    sliderDuration = 100;
    logger.i('Thumb width: $sliderThumbWidth, Track width: $sliderTrackWidth');
  }

  void onSliderDragging(DragUpdateDetails details) {
    double newDx = sliderThumbX.value! + details.primaryDelta!;
    if (0 <= newDx && newDx <= sliderTrackWidth - sliderThumbWidth) {
      sliderThumbX.value = sliderThumbX.value! + details.primaryDelta!;
    }
    logger.i('current dx is: ${sliderThumbX.value}');
  }

  void onSliderDragEnd(DragEndDetails details) {
    sliderDuration = 1000;
    if(sliderThumbX.value! <= sliderThresholdLeft) {
      sliderThumbX.value = 0;
      closeDrawer();
    } else {
      sliderThumbX.value = sliderMaxThumbX;
    }
  }

  void onTimeTrialModeTapped() {
    Get.toNamed('/GuestTtmMatch');
  }

  void onVsModeTapped(AuthState state) async {
    googleSignIn();
    if (state != AuthState.anonymous) {
      Get.toNamed('/Home');
    }
  }

  void googleSignIn() async {
    logger.i('called');
    // isSignIn = true;
    await authController
        .upgradeAnonymousToGoogle()
        .then((value) {
      log('googleSignIn()-> returned value is $value');
      // log('googleSignIn()-> user upgraded...current user Id is ${value.uid} connected with ${value.providerData[0].providerId}');
      // admissionLogic.authUser = value;
      // Get.toNamed('/Home');
    });
    // isSignIn = false;
  }

  Offset getPosition(GlobalKey key) {
    final box = key.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    return position;
  }

  Rect getRect(GlobalKey key) {
    final box = key.currentContext!.findRenderObject() as RenderBox;
    return box.paintBounds;
  }

  void updateSliderFrontPosition() {
    Offset position = getPosition(sliderThumbKey);
    logger.i('before position is: X= ${position.dx}, Y= ${position.dy}');
    sliderThumbX.value = position.dx;
    logger.i('after position is: X= ${sliderThumbX.value}');
  }

  void updateSliderFrontRect() {
    Rect rect = getRect(sliderThumbKey);
    logger.i('before rect position is: Left = ${rect.left}, Top= ${rect.top}');
    sliderThumbX.value = rect.left;
    logger.i('after position is: Left = ${sliderThumbX.value}');
  }


  @override
  void onReady() {
    // updateSliderFrontPosition();
  }

  void onQuitPressed() {
    SystemNavigator.pop();
  }


}
