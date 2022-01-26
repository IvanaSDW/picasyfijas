import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rx<AuthState> _authState = AuthState.signedOut.obs;
  AuthState get authState => _authState.value;
  set authState(AuthState state) => _authState.value = state;

  updateAuthState(User? currentUser) async {
    logger.i('called');
    if (currentUser == null) {
      authState = AuthState.signedOut;
      appController.isFirstRun = true;
      // Get.offAllNamed('/');
    } else if (currentUser.isAnonymous) {
      authState = AuthState.anonymous;
      if(!appController.isFirstRun) appController.refreshPlayer();
      // Get.offAllNamed('/GuestHome');
    } else if (currentUser.providerData.first.providerId == 'google.com'){
      authState = AuthState.google;
      appController.refreshPlayer();
      // Get.offAllNamed('/Home');
    } else {
      logger.e('Could not check sign in method');
    }
    logger.i('Auth state is changed to: $authState');
  }

  @override
  void onInit() {
    auth
        .authStateChanges()
        .listen((User? user) {
      updateAuthState(user);
    });
    // auth
    //     .userChanges()
    //     .listen((User? user) {
    //   if (user == null) {
    //     logger.i('Signing in anonymously...');
    //     appController.isFirstRun = true;
    //     signInAnonymously();
    //   } else {
    //     logger.i('User is signed in!');
    //   }
    // });
    super.onInit();
  }

  Future<void> signInAnonymously() async {
    try {
      final User user = (await auth.signInAnonymously()).user!;
      logger.i('Signed in as ${user.uid}');
      await firestoreService.checkInAnonymousUser(user);
    } catch (e) {
      logger.e('Error signing in anonymously: $e');
    }
  }

  Future<User?> signInWithGoogle() async {
    logger.i('called');
    appController.isBusy = true;
    User? googleUser;
    final GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
    if (signInAccount != null) {
      final GoogleSignInAuthentication signInAuthentication =
      await signInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: signInAuthentication.accessToken,
        idToken: signInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential).then((value) {
        googleUser = value.user!;
        firestoreService.checkInGoogleUser(googleUser!);
        appController.isBusy = false;
      }).catchError((error) {
        logger.e('Error signing in with google: $error');
        appController.isBusy = false;
      });
    } else {
      logger.e('SignIn account returned null');
      appController.isBusy = false;
    }
    return googleUser;
  }

  Future<User?> upgradeAnonymousToGoogle() async {
    logger.i('called');
    if (auth.currentUser == null) {
      logger.i('Currently not signed in');
      return null;
    } else {
      String oldId = auth.currentUser!.uid;
      logger.i('Currently signed in with id: $oldId');
      appController.isBusy = true;
      AuthCredential credential;
      User? googleUser;
      final GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if (signInAccount != null) {
        logger.i('signInAccount is: ${signInAccount.email}');
        final GoogleSignInAuthentication signInAuthentication =
        await signInAccount.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: signInAuthentication.accessToken,
          idToken: signInAuthentication.idToken,
        );
        logger.i('credential is $credential');
        await auth.currentUser!.linkWithCredential(credential).then((value) {
          googleUser = value.user!;
          firestoreService.checkInGoogleUser(googleUser!);
          appController.isBusy = false;
          firestoreService.deletePlayer(oldId);
        }).catchError((error) async {
          logger.e('error linking with credential: $error, hashcode: ${error.hashCode}');
          removeUserAccount();
          await auth.signInWithCredential(credential).then((value) {
            googleUser = value.user!;
            firestoreService.checkInGoogleUser(googleUser!);
            appController.isBusy = false;
            firestoreService.deletePlayer(oldId);
          }).catchError((error) {
            logger.i('Error signing in with google: $error');
            appController.isBusy = false;
          });
        });
      } else {
        logger.i('signInAccount is null: $signInAccount');
        appController.isBusy = false;
      }
      return googleUser;
    }
  }

  Future<void> removeUserAccount() async {
    logger.i('called');
    if (auth.currentUser == null) return;
    return await auth.currentUser!.delete().then((_) {
      logger.i('User account deleted from firebase auth!');
    }).catchError((error) {
      logger.e('Error deleting user account from Firebase: $error)');
    });
  }

  void signOut() async {
    logger.i('called');
    appController.isBusy = true;
    if (auth.currentUser!.isAnonymous) {
      firestoreService.deletePlayer(auth.currentUser!.uid);
      removeUserAccount();
    }
    await auth.signOut().then((value) {
      logger.i('Successfully signed out)');
    }).catchError((error) {
      logger.e('Error signing out: $error');
    });
    appController.isBusy = false;
  }
}