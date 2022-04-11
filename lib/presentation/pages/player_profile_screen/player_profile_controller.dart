import 'package:country_codes/country_codes.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../data/ad_helper.dart';

class PlayerProfileController extends GetxController {

  CountryDetails? country = CountryCodes.detailsForLocale();

  late BannerAd bottomBannerAd;
  final RxBool _isBottomBannerAdLoaded = false.obs;
  bool get isBottomBannerAdLoaded => _isBottomBannerAdLoaded.value;


  @override
  Future<void> onInit() async {
    _createBottomBannerAd();
    super.onInit();
  }

  void _createBottomBannerAd() {
    bottomBannerAd = BannerAd(
      // adUnitId: AdHelper.testProfileBannerAdUnitId,
      adUnitId: AdHelper.profileBannerAdUnitId,
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
}