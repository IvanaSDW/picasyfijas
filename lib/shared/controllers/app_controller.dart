import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:bulls_n_cows_reloaded/model/player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../constants.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  final RxBool _needLand = false.obs;
  bool get needLand => _needLand.value;
  set needLand(bool value) => _needLand.value = value;

  final RxBool needUpdateSoloStats = true.obs;

  final Rx<Player> _currentPlayer = Player.empty().obs;
  set currentPlayer(Player value) => _currentPlayer.value = value;
  Player get currentPlayer => _currentPlayer.value;

  final RxBool _isBusy = false.obs;
  bool get isBusy => _isBusy.value;
  set isBusy(bool value) => _isBusy.value = value;

  final RxBool _isFirstRun = false.obs;
  bool get isFirstRun => _isFirstRun.value;
  set isFirstRun(bool value) => _isFirstRun.value = value;

  late StreamSubscription<InternetConnectionStatus> internetListener;

  final RxString internetStatus = "Not yet checked".obs;

  RxBool hasInterNetConnection = false.obs;

  final Rx<Locale?> _locale = Get.locale.obs;
  Locale? get locale => _locale.value;

  final RxString _countryCode =
      Get.locale.toString().split('_').last.toLowerCase().obs;
  String get countryCode => _countryCode.value;

  Future<void> checkInternet() async {
    internetListener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          internetStatus.value = 'connected'.tr;
          logger.i('Internet status is: ${internetStatus.value}');
          break;
        case InternetConnectionStatus.disconnected:
          internetStatus.value = 'not_connected'.tr;
          logger.i('Internet status is: ${internetStatus.value}');
          break;
      }
    });
  }

  void resetState() {
    logger.i('called');
    drawerSlideValue = 0.0;
    backPanelOn = true;
  }

  void refreshPlayer() async {
    logger.i('called');
    currentPlayer = auth.currentUser == null
        ? Player.empty()
        : await firestoreService.fetchPlayer(auth.currentUser!.uid);
  }

  @override
  void onInit() {
    super.onInit();
    checkInternet();
  }

  final RxDouble _drawerSlideValue = 0.0.obs;
  set drawerSlideValue(value) => _drawerSlideValue.value = value;
  double get drawerSlideValue => _drawerSlideValue.value;
  final panelWidth = Get.width * 0.58;
  final _backPanelOn = true.obs;
  set backPanelOn(bool value) => _backPanelOn.value = value;
  bool get backPanelOn => _backPanelOn.value;

  final _isMuted = false.obs;
  set isMuted(bool value) => _isMuted.value = value;
  bool get isMuted => _isMuted.value;

  final RxDouble _volumeLevel = 1.0.obs;
  set volumeLevel(double value) => _volumeLevel.value = value;
  double get volumeLevel => _volumeLevel.value;

  Future<AudioPlayer> playEffect(String fileName) async {
    AudioCache cache = AudioCache();
    return await cache.play(fileName, volume: isMuted ? 0.0: volumeLevel);
  }

  @override
  void dispose() {
    internetListener.cancel();
    super.dispose();
  }

  quitApp() {
    SystemNavigator.pop(animated: true);
  }

}