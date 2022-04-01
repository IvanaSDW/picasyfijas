import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../data/ad_helper.dart';
import '../../../navigation/routes.dart';


class HomeController extends GetxController {

  late BannerAd bottomBannerAd;
  final RxBool _isBottomBannerAdLoaded = false.obs;
  bool get isBottomBannerAdLoaded => _isBottomBannerAdLoaded.value;

  @override
  void onInit() {
    if (Get.isRegistered<MatrixEffectController>()) Get.delete<MatrixEffectController>();
    appController.stopSplashEffect();
    _createBottomBannerAd();
    super.onInit();
  }

  void _createBottomBannerAd() {
    bottomBannerAd = BannerAd(
      adUnitId: AdHelper.homeBannerAdUnitId,
      size: AdSize.largeBanner,
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

  void onAvatarTapped() {
    // Get.toNamed(Routes.leaderboard);
  }

  void googleSignIn() async {
    logger.i('called');
    await authController
        .upgradeAnonymousToGoogle()
        .then((value) {
      logger.i('Successfully signed in with google');
    });
  }

  onBackPressed() {
    appController.quitApp();
    return false;
  }

  @override
  void dispose() {
    bottomBannerAd.dispose();
    super.dispose();
  }
}
