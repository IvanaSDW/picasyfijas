import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bulls_n_cows_reloaded/data/ip_locator.dart';
import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:bulls_n_cows_reloaded/domain/players_use_cases.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../navigation/routes.dart';
import '../constants.dart';
import '../theme.dart';

class AppController extends GetxController {


  static AppController instance = Get.find();

  AudioPlayer? splashPlayer;
  AudioCache? splashCache;

  final FetchPlayerByIdUC _fetchPlayerById = FetchPlayerByIdUC();

  //Remote Settings
  String playStoreDynamicLink = 'https://bullsncows.page.link/u9DC';
  int botsAllowedQty = 10;
  int botActivateDelaySeconds = 8;

  final RxBool _needLand = false.obs;
  bool get needLand => _needLand.value;
  set needLand(bool value) => _needLand.value = value;

  final RxBool needUpdateSoloStats = true.obs;
  final RxBool needUpdateVsStats = true.obs;
  final RxBool needUpdateLeaderboard = true.obs;

  bool canUpdateAuthState = true;

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

  final _countryCode = RxString(Get.locale.toString().split('_').last.toLowerCase());
  String get countryCode => _countryCode.value;
  set countryCode(String value) => _countryCode.value = value;

  final _countryName = RxString(Get.locale.toString().split('_').last.toLowerCase());
  String get countryName => _countryName.value;
  set countryName(String value) => _countryName.value = value;

  final Rx<AuthState> _authState = AuthState.booting.obs;
  AuthState get authState => _authState.value;
  set authState(AuthState state) => _authState.value = state;

  final RxDouble _drawerSlideValue = 0.0.obs;
  set drawerSlideValue(value) => _drawerSlideValue.value = value;
  double get drawerSlideValue => _drawerSlideValue.value;
  final panelWidth = Get.width * 0.61;
  final _backPanelOn = true.obs;
  set backPanelOn(bool value) => _backPanelOn.value = value;
  bool get backPanelOn => _backPanelOn.value;

  final _isMuted = false.obs;
  set isMuted(bool value) => _isMuted.value = value;
  bool get isMuted => _isMuted.value;

  final RxDouble _volumeLevel = 1.0.obs;
  set volumeLevel(double value) => _volumeLevel.value = value;
  double get volumeLevel => _volumeLevel.value;

  final RxBool p1TimeIsUp = false.obs;
  set setP1TimeIsUp(bool value) => p1TimeIsUp.value = value;
  bool get getP1TimeIsUp => p1TimeIsUp.value;

  final RxBool p2TimeIsUp = false.obs;
  set setP2TimeIsUp(bool value) => p2TimeIsUp.value = value;
  bool get getP2TimeIsUp => p2TimeIsUp.value;

  Future<void> checkInternet() async {
    // logger.i('called');
    internetListener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          internetStatus.value = 'connected'.tr;
          hasInterNetConnection.value = true;
          break;
        case InternetConnectionStatus.disconnected:
          internetStatus.value = 'not_connected'.tr;
          hasInterNetConnection.value = false;
          break;
      }
    });
  }

  void resetState() {
    drawerSlideValue = 0.0;
    backPanelOn = true;
  }

  Future<void> refreshPlayer() async {
    currentPlayer = await _fetchPlayerById(auth.currentUser!.uid)
        .then((player) {
      if (player == null) {
        needLand = true;
        authService.signOut();
        return Player.empty();
      } else {
        if (!auth.currentUser!.isAnonymous && appController.hasInterNetConnection.value) {
          auth.currentUser!.providerData[0].photoURL == player.photoUrl
              ? null : player.photoUrl = auth.currentUser!.providerData[0].photoURL;
        }
        return player;
      }
    });
  }

  void refreshNickName(String nickName) {
    _currentPlayer.update((val) {
      val?.nickName = nickName;
    });
  }

  void refreshAvatar(String avatarUrl) {
    _currentPlayer.update((val) {
      val?.addedAvatarsUrls?.add(avatarUrl);
    });
  }


  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    volumeLevel = prefs.getDouble('volumeLevel') ?? 1.0;
    isMuted = prefs.getBool('isMuted') ?? false;
    // logger.i('Read volume level: $volumeLevel');
    await checkInternet();
    countryCode = await IpLocator().getCountryCode();
    countryName = await IpLocator().getCountryName();
    fetchRemoteSettings();
    if(currentPlayer.pushToken == null) {
      FirebaseMessaging.instance.getToken().then((value) => {
        firestoreService.updatePlayerToken(playerId: auth.currentUser!.uid, newToken: value!)
      }
      );
    }
  }

  void fetchRemoteSettings() async {
    await firestoreService.fetchRemoteSettings().then((value) {
      if(value != null) {
        playStoreDynamicLink = value[appSettingsPlayStoreDynamicLinkFN] ?? 'https://bullsncows.page.link/u9DC';
        botsAllowedQty = value[appSettingsBotsAllowedQtyFn] ?? 10;
        botActivateDelaySeconds = value[appSettingsBotActivateDelaySecondsFN] ?? 8;
      }
    });
  }

  Future<AudioPlayer> playEffect(String fileName) async {
    AudioCache cache = AudioCache();
    return await cache.play(fileName, volume: isMuted ? 0.0: volumeLevel,);
  }

  void playSplashEffect(String fileName, double volume) async {
    splashCache = AudioCache(fixedPlayer: splashPlayer);
    // logger.i('Volume at start: $volumeLevel, is mute: $isMuted');
    splashPlayer = await splashCache?.play(fileName, volume: volume,);
  }

  void stopSplashEffect() {
    splashPlayer?.stop();
    splashCache?.clearAll();
  }

  updateAuthState(User? currentUser) async {
    if (!canUpdateAuthState) {
      canUpdateAuthState = true;
      return;
    }
    if (currentUser == null) { //firs app run (or first run after last signed out)
      if (authState != AuthState.signedOut) {
        authState = AuthState.signedOut;
        if(!isUpgrade) {
          isFirstRun = true;
          if (needLand) {
            Get.offAllNamed(Routes.landing);
            isBusy = false;
          } else {
            firstSignIn();
          }
        }
      } else {
      }
    } else if (currentUser.isAnonymous) {
      if (authState != AuthState.anonymous) {
        authState = AuthState.anonymous;
        if (isFirstRun) { //Just signed in anonymously
          await firestoreService.checkInAnonymousPlayer(currentUser);
          await Future.delayed(const Duration(seconds: 8));
          Get.offAllNamed(Routes.home);
          appController.isBusy = false;
          //Player object will be refreshed there;
        } else { //App run from already signed anonymous user
          await refreshPlayer();
          await Future.delayed(const Duration(seconds: 4));
          Get.offAllNamed(Routes.home);
          appController.isBusy = false;
        }
      } else {
        logger.i('called again for same auth event. ignoring...');
      }
    } else //User is not anonymous
    if (currentUser.providerData.first.providerId == 'google.com'){ //User is signed in with Google account
      if (authState != AuthState.google) {
        authState = AuthState.google;
        await Future.delayed(const Duration(seconds: 2));
        if (isUpgrade) { //Just signed with Google from previous anonymous account
          await refreshPlayer();
        } else { //App run from already signed google user
          await refreshPlayer();
          await Future.delayed(const Duration(seconds: 4));
          Get.offAllNamed(Routes.home);
          appController.isBusy = false;
        }
      } else {
      }
    } else { //User is not anonymous nor google. Death end.
    }
  }

  void firstSignIn() async {
    appController.isBusy = true;
    await authController.signInAnonymously();
  }

  void savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('volumeLevel', volumeLevel);
    prefs.setBool('isMuted', isMuted);
  }

  @override
  void dispose() {
    internetListener.cancel();
    super.dispose();
  }

  quitApp() {
    Get.defaultDialog(
        title: 'press_exit_to_leave_app'.tr,
        middleText: '',
        // middleText: 'press_exit_to_leave_app'.tr,
        textConfirm: 'exit'.tr,
        textCancel: 'cancel'.tr,
        backgroundColor: Colors.green.withOpacity(0.6),
        buttonColor: originalColors.accentColor2,
        cancelTextColor: originalColors.reverseTextColor,
        confirmTextColor: originalColors.textColorLight,
        onConfirm: () => SystemNavigator.pop(animated: true)
    );
  }

}