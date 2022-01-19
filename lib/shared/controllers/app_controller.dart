import 'dart:async';
import 'dart:ui';

import 'package:bulls_n_cows_reloaded/model/player.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../constants.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  final Rx<Player> _currentPlayer = Player.empty().obs;
  set currentPlayer(value) => _currentPlayer.value = value;
  get currentPlayer => _currentPlayer.value;

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
          internetStatus.value = "Connected to Internet";
          logger.i('Internet status is: ${internetStatus.value}');
          break;
        case InternetConnectionStatus.disconnected:
          internetStatus.value = "No Internet connection";
          logger.i('Internet status is: ${internetStatus.value}');
          break;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkInternet();
  }

  @override
  void dispose() {
    internetListener.cancel();
    super.dispose();
  }

}