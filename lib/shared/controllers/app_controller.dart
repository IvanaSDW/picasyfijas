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
  final RxBool needUpdateVsStats = true.obs;

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

  final RxBool p1TimeIsUp = false.obs;
  set setP1TimeIsUp(bool value) => p1TimeIsUp.value = value;
  bool get getP1TimeIsUp => p1TimeIsUp.value;

  final RxBool p2TimeIsUp = false.obs;
  set setP2TimeIsUp(bool value) => p2TimeIsUp.value = value;
  bool get getP2TimeIsUp => p2TimeIsUp.value;

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
    firestoreService.reportOnline();
  }

  Future<AudioPlayer> playEffect(String fileName) async {
    AudioCache cache = AudioCache();
    return await cache.play(fileName, volume: isMuted ? 0.0: volumeLevel);
  }

  updateAuthState(User? currentUser) async {
    if (!canUpdateAuthState) {
      canUpdateAuthState = true;
      return;
    }
    logger.i('called when current user is $currentUser');
    if (currentUser == null) { //firs app run (or first run after last signed out)
      logger.i('Current user is null, authState: $authState, first run: $isFirstRun, needLand: $needLand');
      if (authState != AuthState.signedOut) {
        logger.i('just signed out');
        authState = AuthState.signedOut;
        if(!appController.isUpgrade) {
          isFirstRun = true;
          logger.i('isFirstRun is now = $isFirstRun');
          if (appController.needLand) Get.offAllNamed(Routes.landing);
        }
        firstSignIn();
      } else {
        logger.i('called again for same auth event. ignoring...');
      }
    } else if (currentUser.isAnonymous) {
      logger.i('authState is: ${authState.toString().split('.').last}');
      if (authState != AuthState.anonymous) {
        authState = AuthState.anonymous;
        logger.i('authState is now: $authState, isFirstRun: $isFirstRun');
        if (isFirstRun) { //Just signed in anonymously
          await firestoreService.checkInAnonymousPlayer(currentUser);
          logger.i('Anonymous player should have been checked in in firestore. Taking user to homepage...');
          Get.offAllNamed(Routes.home);
          //Player object will be refreshed there;
        } else { //App run from already signed anonymous user
          logger.i('App run from already signed anonymous user: ${currentUser.uid}, .. refreshing player object');
          await refreshPlayer();
          await Future.delayed(const Duration(seconds: 3));
          logger.i('Taking anonymous user to Home page..');
          Get.offAllNamed(Routes.home);
        }
      } else {
        logger.i('called again for same auth event. ignoring...');
      }
    } else //User is not anonymous
    if (currentUser.providerData.first.providerId == 'google.com'){ //User is signed in with Google account
      logger.i('User is signed in with Google');
      if (authState != AuthState.google) {
        authState = AuthState.google;
        await Future.delayed(const Duration(seconds: 3));
        if (isUpgrade) { //Just signed with Google from previous anonymous account
          await refreshPlayer();
          logger.i('Just upgraded to Google user... should change player avatar');
        } else { //App run from already signed google user
          logger.i('App run from already signed google user.. refreshing player object...');
          await refreshPlayer();
          await Future.delayed(const Duration(seconds: 3));
          logger.i('Navigating to home page');
          Get.offAllNamed(Routes.home);
        }
      } else {
        logger.i('called again for same auth event. ignoring...');
      }
    } else { //User is not anonymous nor google. Death end.
      logger.i('Could not check sign in method');
    }
  }

  void firstSignIn() async {
    logger.i('called');
    appController.isBusy = true;
    await authController.signInAnonymously();
    appController.isBusy = false;
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