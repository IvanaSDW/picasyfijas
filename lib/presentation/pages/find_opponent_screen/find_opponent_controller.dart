import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:bulls_n_cows_reloaded/navigation/routes.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../shared/constants.dart';
import '../../../shared/managers/versus_match_maker.dart';

class FindOpponentController extends GetxController {

  VersusMatchMaker matchMaker = VersusMatchMaker();

  final RxBool _matrixVisible = true.obs;
  get matrixVisible => _matrixVisible.value;

  bool isPlayingAgainstBot = false;

  @override
  void onInit() {
    super.onInit();
    matchMaker.onGameCreated((stream, gameReference, isPlayerOne) async {
      Player? _opponentPlayer;
      Player? _playerOnePlayer;
      Player? _playerTwoPlayer;
      if (isPlayerOne) {
        await gameReference.get().then((value) async {
          if( !value.exists) {
          } else {
            _playerOnePlayer = appController.currentPlayer;
            _playerTwoPlayer = (await firestoreService.fetchPlayer(value.data()!.playerTwoId))!;
            _opponentPlayer = _playerTwoPlayer;
          }
        });
      } else {
        await gameReference.get().then((value) async {
          if(!value.exists) {
            logger.i('Game reference $gameReference does not exist!!');
          } else {
            logger.i('We are player 2, fetching opponent player object from firestore');
            _playerOnePlayer = (await firestoreService.fetchPlayer(value.data()!.playerOneId))!;
            _playerTwoPlayer = appController.currentPlayer;
            _opponentPlayer = _playerOnePlayer;
          }
        });
      }
      HapticFeedback.mediumImpact();
      appController.playEffect('audio/match_created.wav');
      Get.offAndToNamed(Routes.versusGame,
          arguments: {
            'gameStream' : stream,
            'isPlayerOne' : isPlayerOne,
            'gameReference' : gameReference,
            'opponentPlayer' : _opponentPlayer,
            'playerOneObject' : _playerOnePlayer,
            'playerTwoObject' : _playerTwoPlayer,
            'isPlayingAgainstBot' : isPlayingAgainstBot,
          });
    });
    matchMaker.makeMatch(playerId: appController.currentPlayer.id!);
    Future.delayed(const Duration(seconds: 5), () {
      _matrixVisible.value = false;
      Get.delete<MatrixEffectController>(tag: 'find_opponent');
    });
    Future.delayed(const Duration(seconds: 6), () {
      activateBot();
    });
  }

  void activateBot () {
    logger.i('called');
    // appController.botPlayerImage.evict();
    isPlayingAgainstBot = true;
    matchMaker.makeMatchWithRobot(playerId: appController.currentPlayer.id!);
  }

  void onChallengeCanceled() {
    matchMaker.cancelChallenge();
  }
}
