import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../shared/constants.dart';

class FirebaseAuthService {
  static FirebaseAuthService instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<void> signInAnonymously() async {
  //   try {
  //     final User user = (await auth.signInAnonymously()).user!;
  //     logger.i('Signed in as ${user.uid}');
  //     await firestoreService.checkInAnonymousUser(user);
  //   } catch (e) {
  //     logger.i('Error signing in anonymously: $e');
  //   }
  // }

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
        appController.isBusy = false;
      });
    } else {
      logger.e('SignIn account returned null');
      appController.isBusy = false;
    }
    return googleUser;
  }

  // Future<User?> upgradeAnonymousToGoogle() async {
  //   logger.i('called');
  //   if (auth.currentUser == null) {
  //     logger.i('Currently not signed in');
  //     return null;
  //   } else {
  //     String oldId = auth.currentUser!.uid;
  //     logger.i('Currently signed in with id: $oldId');
  //     appController.isBusy = true;
  //     AuthCredential credential;
  //     User? googleUser;
  //     final GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
  //     if (signInAccount != null) {
  //       logger.i('Google account to link: ${signInAccount.email}');
  //       final GoogleSignInAuthentication signInAuthentication =
  //       await signInAccount.authentication;
  //       credential = GoogleAuthProvider.credential(
  //         accessToken: signInAuthentication.accessToken,
  //         idToken: signInAuthentication.idToken,
  //       );
  //       logger.i('credential is $credential');
  //       await auth.currentUser!.linkWithCredential(credential).then((value) async {
  //         googleUser = value.user!;
  //         appController.updateAuthState(googleUser);
  //         await firestoreService.checkInGoogleUser(googleUser!);
  //         appController.isBusy = false;
  //         // firestoreService.deletePlayer(oldId);
  //       }).catchError((error) async {
  //         logger.e('error linking with credential: $error, hashcode: ${error.hashCode}');
  //         removeUserAccount(auth.currentUser!);
  //         // removeUserAccount();
  //         await auth.signInWithCredential(credential).then((value) async {
  //           googleUser = value.user!;
  //           await firestoreService.checkInGoogleUser(googleUser!);
  //           appController.isBusy = false;
  //           firestoreService.moveOldIdSoloMatches(oldId, googleUser!.uid);
  //           firestoreService.deletePlayer(oldId);
  //         }).catchError((error) {
  //           logger.i('Error signing in with google: $error');
  //           appController.isBusy = false;
  //         });
  //       });
  //     } else {
  //       logger.i('signInAccount is null: $signInAccount');
  //       appController.isBusy = false;
  //     }
  //     return googleUser;
  //   }
  // }

  Future<dynamic> signAnonymousToGoogle(User user) async {
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
        })
        .catchError((error) {
          userOrCredential = credential;
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