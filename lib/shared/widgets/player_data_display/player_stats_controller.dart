import 'package:bulls_n_cows_reloaded/model/player_solo_stats.dart';
import 'package:bulls_n_cows_reloaded/model/solo_match.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:get/get.dart';


class PlayerStatsController extends GetxController {

  late List<SoloMatch>? myMatches;
  final Rx<PlayerSoloStats?> _playerSoloStats = PlayerSoloStats.blank().obs;
  set playerSoloStats(PlayerSoloStats? stats) => _playerSoloStats.value = stats;
  PlayerSoloStats? get playerSoloStats => _playerSoloStats.value;

  refreshStats() async {
    logger.i('called');
    if (appController.needUpdateSoloStats.value) {
      playerSoloStats = await statsService.calcPlayerStats(appController.currentPlayer.id!);
      appController.needUpdateSoloStats.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await refreshStats();
    ever(appController.needUpdateSoloStats, (value) => refreshStats());
  }

}
