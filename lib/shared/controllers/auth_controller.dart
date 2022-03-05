import 'package:bulls_n_cows_reloaded/domain/firebase_auth_use_cases.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
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
            (user) {
          if(user != null ) firestoreService.checkInAnonymousPlayer(user);
        }
    );
  }

  Future<void> signInWithGoogle() async {
    await _signInWithGoogle().then(
            (user) {
          if (user != null) firestoreService.checkInGooglePlayer(user);
        }
    );
  }

  Future<void> upgradeAnonymousToGoogle() async {
    appController.isBusy = true;
    String oldId = auth.currentUser!.uid;
    logger.i('Current anonymous id: $oldId');
    await _signInAnonymousToGoogle(auth.currentUser!)
        .then((value) async {
      appController.isUpgrade = true;
      if (value is User) {
        appController.updateAuthState(value);
        await firestoreService.checkInGooglePlayer(value);
        appController.isBusy = false;
      } else if (value is String) {
        appController.isBusy = false;
      } else if (value is AuthCredential){
        logger.e('error when linking account with credential: $value');
        _removeUserAccount(auth.currentUser!);
        _signInWithCredential(value)
            .then((value) async {
          if (value != null) {
            await firestoreService.checkInGooglePlayer(value);
            firestoreService.moveOldIdSoloGames(oldId, value.uid);
            appController.needUpdateSoloStats.value = true;
            firestoreService.deletePlayer(oldId);
            appController.isBusy = false;
          } else {
            logger.e('Sign in with credential returned null user');
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
    await _signOut();
  }

  void listenToUserChanges() {
    auth.userChanges()
        .listen((User? user) {
      logger.i('UserChanges event occurred...');
      appController.updateAuthState(user);
    });
  }

  void listenToAuthStateChanges() {
    auth.authStateChanges()
        .listen((User? user) {
      logger.i('AuthStateChanges event occurred...');
      appController.updateAuthState(user);
    });
  }


}