import 'package:get/get.dart';


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

}
