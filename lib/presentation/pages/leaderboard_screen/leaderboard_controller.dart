import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../data/ad_helper.dart';
import '../../../data/models/player.dart';


class LeaderboardController extends GetxController {

  final RxList<Player> _vsLeaderBoard = <Player>[].obs;
  List<Player> get vsLeaderboard => _vsLeaderBoard;

  final RxList<Player> _soloLeaderBoard = <Player>[].obs;
  List<Player> get soloLeaderboard => _soloLeaderBoard;

  late BannerAd bottomBannerAd;
  final RxBool _isBottomBannerAdLoaded = false.obs;
  bool get isBottomBannerAdLoaded => _isBottomBannerAdLoaded.value;

  final RxBool _isSyncing = false.obs;
  set isSyncing(bool value) => _isSyncing.value = value;
  bool get isSyncing => _isSyncing.value;

  final RxBool _showVersus = true.obs;
  set showVersus(bool value) => _showVersus.value = value;
  bool get showVersus => _showVersus.value;

  @override
  void onInit() async {
    super.onInit();
    await refreshVsLeaderboard();
    _createBottomBannerAd();
  }

  Future<void> refreshVsLeaderboard() async {
    isSyncing = true;
    _vsLeaderBoard.value = await firestoreService.getVsLeaderboard();
    _soloLeaderBoard.value = await firestoreService.getSoloLeaderboard();
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