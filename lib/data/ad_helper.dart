import 'package:get/get.dart';

class AdHelper {
  static String get homeBannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-9780033679028237/3862720203";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get profileBannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-9780033679028237/3393824646";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get leaderboardBannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-9780033679028237/3862197114";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get afterSoloGameInterstitialAdUnitId {
    if (GetPlatform.isAndroid) {
      return "cca-app-pub-9780033679028237/7736086842";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get afterVersusGameInterstitialAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-9780033679028237/8199412854";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }


  static String get testHomeBannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get testProfileBannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get testLeaderboardBannerAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }


  static String get testInterstitialAdUnitId {
    if (GetPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}