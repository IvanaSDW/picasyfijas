import 'dart:async';

import 'package:bulls_n_cows_reloaded/data/repository/auth_repository.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl extends AuthRepository {

  @override
  Future<void> removeUserAccount(User user) async {
    await authService.removeUserAccount(user);
  }

  @override
  Future<User?> signInAnonymously() async {
    return await authService.signInAnonymously()
    .then((user) => user);
  }

  @override
  Future<User?> signInWithGoogle() async {
    return await authService.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return await authService.signOut();
  }

  @override
  Future signInAnonymousToGoogle(User user) async {
    return await authService.signAnonymousToGoogle(user);
  }

  @override
  Future<User?> signInWithCredential(AuthCredential credential) async {
    return await authService.signInWithCredential(credential);
  }

}