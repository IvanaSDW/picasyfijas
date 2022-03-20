import 'package:get/get.dart';

class AdHelper {
  static String get homeBannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (GetPlatform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get profileBannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (GetPlatform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (GetPlatform.isIOS) {
      return "ca-app-pub-3940256099942544/5135589807";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}