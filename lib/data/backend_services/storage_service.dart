import 'dart:io';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageService {

  Future<String> uploadFile(File file) async {
    String downloadUrl = "";
    try {
      String baseName = basename(file.path);
      await fbStorage.ref('$playerAvatarStorageTN/$baseName${DateTime.now()}')
          .putFile(file)
      .then((p0) => p0.ref.getDownloadURL().then((url) => downloadUrl = url));
      logger.i("Successfully upload file $file");
      return downloadUrl;
    } on FirebaseException catch (e) {
      logger.i('error is ${e.message}');
      return 'error';
    }
  }

}