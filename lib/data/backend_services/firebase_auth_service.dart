import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../shared/constants.dart';

class FirebaseAuthService {
  static FirebaseAuthService instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInAnonymously() async {
    return await _auth.signInAnonymously()
        .then((credential) => credential.user)
        .catchError((e) {logger.i('Error signing in anonymously: $e');});
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
        appController.isBusy = false;
      }).catchError((error) {
        logger.e('Error signing in with google: $error');
        if (error.toString().contains('The supplied auth credential is malformed or has expired')) {
          Get.defaultDialog(
              title: 'Authentication error.',
            middleText: 'Is possible that your device time zone is not correctly set. Please check and try again.'
          );
        }
        appController.isBusy = false;
      });
    } else {
      logger.e('SignIn account returned null');
      appController.isBusy = false;
    }
    return googleUser;
  }

  Future<dynamic> signAnonymousToGoogle(User user) async {
    logger.i('Upgrading user ${user.uid} to Google account...');
    AuthCredential credential;
    dynamic userOrCredential;
    await _googleSignIn.signIn()
        .then((account) async {
      logger.i('Google account to link: ${account?.email}');
      if (account != null) {
        final GoogleSignInAuthentication signInAuthentication =
        await account.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: signInAuthentication.accessToken,
          idToken: signInAuthentication.idToken,
        );
        await user.linkWithCredential(credential)
            .then((credential) {
          userOrCredential = credential.user;
          logger.i('Account linked successfully. Returning user: $userOrCredential');
        })
        .catchError((error) {
          userOrCredential = credential;
          logger.e('Error linking with credential: $error');
          logger.i('Returning credential: $userOrCredential');
        });
      } else {
        logger.i('Account null when signing in to google');
        userOrCredential = 'signInAborted';
      }
    });
    return userOrCredential;
  }

  Future<User?> signInWithCredential(AuthCredential credential) async {
    return await auth.signInWithCredential(credential)
        .then((value) => value.user)
        .catchError((error) {
      logger.i('Error signing in with credential: $error');
    });
  }

  Future<void> removeUserAccount(User user) async {
    logger.i('called');
    return await user.delete().then((_) {
      logger.i('User account deleted from firebase auth!');
    }).catchError((error) {
      logger.e('Error deleting user account from Firebase: $error)');
    });
  }

  Future<void> signOut() async {
    logger.i('called');
    appController.isBusy = true;
    appController.needLand = true;
    if (auth.currentUser!.isAnonymous) {
      firestoreService.deletePlayer(auth.currentUser!.uid);
      await removeUserAccount(auth.currentUser!);
    }
    try {
      await auth.signOut();
      logger.i('Successfully signed out');
    } on PlatformException catch (e) {
      logger.e('Error signing out: ${e.toString()}');
    }

    appController.isBusy = false;
  }
}