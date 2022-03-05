import 'package:bulls_n_cows_reloaded/data/repository/auth_repository.dart';
import 'package:bulls_n_cows_reloaded/data/repository/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignInAnonymouslyUC {
  final AuthRepository _authRepository = Get.put(AuthRepositoryImpl());
  Future<User?> call() async {
    return _authRepository.signInAnonymously();
  }
}

class SignInWithGoogleUC {
  final AuthRepository _authRepository = Get.put(AuthRepositoryImpl());
  Future<User?> call() async {
    return _authRepository.signInWithGoogle();
  }
}

class SignInAnonymousToGoogleUC {
  final AuthRepository _authRepository = Get.put(AuthRepositoryImpl());
  Future<dynamic> call(User user) async {
    return _authRepository.signInAnonymousToGoogle(user);
  }
}

class RemoveUserAccountUC {
  final AuthRepository _authRepository = Get.put(AuthRepositoryImpl());
  Future<void> call(User user) async {
    return _authRepository.removeUserAccount(user);
  }
}

class SignInWithCredentialUC {
  final AuthRepository _authRepository = Get.put(AuthRepositoryImpl());
  Future<User?> call(AuthCredential credential) async {
    return _authRepository.signInWithCredential(credential);
  }
}

class SignOutUC {
  final AuthRepository _authRepository = Get.put(AuthRepositoryImpl());
  Future<void> call() async {
    _authRepository.signOut();
  }
}