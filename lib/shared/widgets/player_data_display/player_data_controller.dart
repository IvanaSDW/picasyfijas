import 'package:get/get.dart';
// import 'package:getwidget/components/alert/gf_alert.dart';


class PlayerDataDisplayController extends GetxController {

  String? playerId;

  final RxString _ttmTimeAverage = 'requires_google'.tr.obs;
  final RxString _ttmGuessAverage = 'requires_google'.tr.obs;
  final RxString _ttmWorldRank = 'requires_google'.tr.obs;
  final RxString _vmWinRate = 'requires_google'.tr.obs;
  final RxString _vmWorldRank = 'requires_google'.tr.obs;

  String get ttmTimeAverage => _ttmTimeAverage.value;
  String get ttmWorldRank => _ttmWorldRank.value;
  String get ttmGuessAverage => _ttmGuessAverage.value;
  String get vmWinRate => _vmWinRate.value;
  String get vmWorldRank => _vmWorldRank.value;


  @override
  void onInit() {
    super.onInit();

  }

  signOut() {
    // Get.dialog(
    //     GFAlert(
    //       title: 'Signing Out...',
    //     )
    // );
    // authController.signOut();
  }
}
