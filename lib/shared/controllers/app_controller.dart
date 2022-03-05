import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:bulls_n_cows_reloaded/domain/players_use_cases.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../navigation/routes.dart';
import '../constants.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  final FetchPlayerByIdUC _fetchPlayerById = FetchPlayerByIdUC();

  final RxBool _needLand = false.obs;
  bool get needLand => _needLand.value;
  set needLand(bool value) => _needLand.value = value;

  final RxBool needUpdateSoloStats = true.obs;

  final RxBool _isUpgrade = false.obs;
  set isUpgrade(value) => _isUpgrade.value = value;
  bool get isUpgrade => _isUpgrade.value;

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

  final Rx<AuthState> _authState = AuthState.booting.obs;
  AuthState get authState => _authState.value;
  set authState(AuthState state) => _authState.value = state;

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

  Future<void> refreshPlayer() async {
    logger.i('called');
    currentPlayer = await _fetchPlayerById(auth.currentUser!.uid)
    .then((player) {
      if (player == null) {
        logger.wtf('Player may have been deleted from firestore. Exiting...');
        appController.authState = AuthState.signedOut;
        appController.needLand = true;
        authService.signOut();
        return Player.empty();
      } else {
        return player;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkInternet();
  }

  Future<AudioPlayer> playEffect(String fileName) async {
    AudioCache cache = AudioCache();
    return await cache.play(fileName, volume: isMuted ? 0.0: volumeLevel);
  }

  updateAuthState(User? currentUser) async {
    logger.i('called');
    if (currentUser == null) {
      logger.i('authState is: $authState and current user is now null, needLand is: ${appController.needLand}');
      if (authState != AuthState.signedOut) {
        authState = AuthState.signedOut;
        if(!appController.isUpgrade) isFirstRun = true;
        if(!appController.isUpgrade) if (appController.needLand) Get.offAllNamed(Routes.landing);
      } else {
        logger.i('called again for same auth event. ignoring...');
      }
    } else if (currentUser.isAnonymous) {
      logger.i('authState is: ${authState.toString().split('.').last}');
      if (authState != AuthState.anonymous) {
        authState = AuthState.anonymous;
        if(!isFirstRun) await refreshPlayer();
        await Future.delayed(const Duration(seconds: 3));
        if(!appController.isUpgrade) Get.offAllNamed(Routes.home);
      } else {
        logger.i('called again for same auth event. ignoring...');
      }
    } else if (currentUser.providerData.first.providerId == 'google.com'){
      if (authState != AuthState.google) {
        authState = AuthState.google;
        await refreshPlayer();
        await Future.delayed(const Duration(seconds: 3));
        resetState();
        if(!appController.isUpgrade) Get.offAllNamed(Routes.home);
      } else {
        logger.i('called again for same auth event. ignoring...');
      }
    } else {
      logger.i('Could not check sign in method');
    }
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