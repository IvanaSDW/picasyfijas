import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../data/ad_helper.dart';
import '../../../data/models/player.dart';


class LeaderboardController extends GetxController {

  final RxList<Player> _leaderBoard = <Player>[].obs;
  List<Player> get leaderboard => _leaderBoard;

  late BannerAd bottomBannerAd;
  final RxBool _isBottomBannerAdLoaded = false.obs;
  bool get isBottomBannerAdLoaded => _isBottomBannerAdLoaded.value;

  final RxBool _isSyncing = false.obs;
  set isSyncing(bool value) => _isSyncing.value = value;
  bool get isSyncing => _isSyncing.value;

  @override
  void onInit() async {
    super.onInit();
    await refreshLeaderboard();
    _createBottomBannerAd();
  }

  Future<void> refreshLeaderboard() async {
    isSyncing = true;
    _leaderBoard.value = await firestoreService.getLeaderboard();
    appController.needUpdateLeaderboard.value = false;
    isSyncing = false;
  }

  void _createBottomBannerAd() {
    bottomBannerAd = BannerAd(
      // adUnitId: AdHelper.testLeaderboardBannerAdUnitId,
      adUnitId: AdHelper.leaderboardBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBottomBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    bottomBannerAd.load();
  }

}