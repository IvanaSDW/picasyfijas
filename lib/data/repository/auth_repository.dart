import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {

  Future<User?> signInAnonymously();

  Future<User?> signInWithGoogle();

  Future<dynamic> signInAnonymousToGoogle(User user);

  Future<User?> signInWithCredential(AuthCredential credential);

  Future<void> removeUserAccount(User user);

  Future<void> signOut();

}