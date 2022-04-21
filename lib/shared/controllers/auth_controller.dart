import 'package:bulls_n_cows_reloaded/domain/firebase_auth_use_cases.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../theme.dart';

class AuthController extends FullLifeCycleController with FullLifeCycleMixin{
  static AuthController instance = Get.find();
  final SignInAnonymouslyUC _signInAnonymously = SignInAnonymouslyUC();
  final SignInWithGoogleUC _signInWithGoogle = SignInWithGoogleUC();
  final SignInAnonymousToGoogleUC _signInAnonymousToGoogle = SignInAnonymousToGoogleUC();
  final RemoveUserAccountUC _removeUserAccount = RemoveUserAccountUC();
  final SignInWithCredentialUC _signInWithCredential = SignInWithCredentialUC();
  final SignOutUC _signOut = SignOutUC();

  @override
  void onInit() {
    // subscribeToUserChanges();
    listenToAuthStateChanges();
    super.onInit();
  }

  Future<void> signInAnonymously() async {
    await _signInAnonymously().then(
            (user) async {
          if(user != null ) {
          }
        }
    );
  }

  Future<void> signInWithGoogle() async {
    appController.isBusy = true;
    await _signInWithGoogle().then(
            (user) async {
          if (user != null) {
            await firestoreService.checkInGooglePlayer(user, false);
          }
          appController.isBusy = false;
        }
    );
  }

  Future<void> upgradeAnonymousToGoogle() async {
    appController.isBusy = true;
    String oldId = auth.currentUser!.uid;
    await _signInAnonymousToGoogle(auth.currentUser!)
        .then((userOrCredential) async {
      appController.isUpgrade = true;
      if (userOrCredential is User) {
        await firestoreService.checkInGooglePlayer(userOrCredential, true);
        appController.updateAuthState(userOrCredential);
        appController.isBusy = false;
      } else if (userOrCredential is String) {
        appController.isBusy = false;
      } else if (userOrCredential is AuthCredential){
        logger.i('Will sign in with returned credential: $userOrCredential ...');
        appController.canUpdateAuthState = false;
        _removeUserAccount(auth.currentUser!);
        _signInWithCredential(userOrCredential)
            .then((value) async {
          if (value != null) {
            await firestoreService.checkInGooglePlayer(value, true);
            firestoreService.moveOldIdSoloGames(oldId, value.uid);
            appController.needUpdateSoloStats.value = true;
            appController.needUpdateVsStats.value = true;
            firestoreService.deletePlayer(oldId);
            appController.isBusy = false;
          } else {
            logger.e('Sign in with credential returned null user');
            Get.defaultDialog(
                title: 'authentication_error'.tr,
                middleText: 'Could be a time zone error in your device'.tr,
                textConfirm: 'ok'.tr,
                backgroundColor: Colors.green.withOpacity(0.6),
                buttonColor: originalColors.accentColor2,
                confirmTextColor: originalColors.textColorLight,
                onConfirm: () => SystemNavigator.pop(animated: true)
            );
            appController.isBusy = false;
          }
        });
      }
    });
  }

  Future<void> removeUserAccount(User user) async {
    await _removeUserAccount(user);
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    await _signInWithCredential(credential);
  }

  Future<void> signOut() async {
    Get.defaultDialog(
        title: 'press_confirm_to_logout'.tr,
        middleText: '',
        textConfirm: 'confirm'.tr,
        textCancel: 'cancel'.tr,
        backgroundColor: Colors.green.withOpacity(0.5),
        buttonColor: originalColors.accentColor2,
        cancelTextColor: originalColors.reverseTextColor,
        confirmTextColor: originalColors.textColorLight,
        onConfirm: () => _signOut(),
    );

  }

  void listenToUserChanges() {
    auth.userChanges()
        .listen((User? user) {
      logger.i('UserChanges event occurred...');
      appController.updateAuthState(user);
    });
  }

  void listenToAuthStateChanges() { //App entry point
    auth.authStateChanges()
        .listen((User? user) {
      appController.updateAuthState(user);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // logger.i('App lifecycle state changed to resumed');
        break;
      case AppLifecycleState.inactive:
        // logger.i('App lifecycle state changed to inactive');
        break;
      case AppLifecycleState.paused:
        // logger.i('App lifecycle state changed to paused');
        break;
      case AppLifecycleState.detached:
        // logger.i('App lifecycle state changed to detached');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onDetached() async {
    // logger.i('App lifecycle state changed to detached');
    // await firestoreService.reportOffline();
  }

  @override
  void onInactive() {
    // logger.i('App lifecycle state changed to inactive');
  }

  @override
  void onPaused() async {
    // logger.i('App lifecycle state changed to paused');
    // await firestoreService.reportOffline();
  }

  @override
  void onResumed() {
    // logger.i('App lifecycle state changed to resumed');
    // firestoreService.reportOnline();
  }
}