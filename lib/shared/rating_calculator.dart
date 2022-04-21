import 'dart:math';

import 'package:bulls_n_cows_reloaded/shared/constants.dart';

class RatingCalculator {
  
  Future<int> getInitialRating(String playerId) async {
    final initialGames = await firestoreService.getInitialVsGamesByPlayerId(playerId);
    int sumOfOppRating = 0;
    double score = 0;
    for (var game in initialGames) {
      if(game.playerOneId == playerId) {
        sumOfOppRating += game.p2Rating;
      } else {
        sumOfOppRating += game.p1Rating;
      }
      if (game.winnerId == 'draw') {
        score += 0.5;
      } else if (game.winnerId == playerId) {
        score += 1.0;
      }
    }
    int gameCount = initialGames.length;
    int kFactor = kFactorForInitialRating;
    int averageOppRating = sumOfOppRating ~/ gameCount;
    int initialRating = (averageOppRating + (score - gameCount*0.5) * kFactor).round();
    return initialRating;
  }

  Future<int> getRatingChange(int playerRating, int oppRating, double score) async {
    int ratingDelta = (oppRating - playerRating).abs();
    double deltaRatio = ratingDelta / 400;
    double expectedScore = 1 / (1 + (pow(10, deltaRatio)));
    int kFactor = playerRating < 2400 ? kFactorBelow2400 : kFactorAbove2400;
    int ratingChange = (kFactor * (score - expectedScore)).round();
    return ratingChange;
  }

  Future<int> getNewRating(int playerRating, int oppRating, double score) async {
    int ratingChange = await getRatingChange(playerRating, oppRating, score);
    return playerRating + ratingChange;
  }
  
  Future<int> rebuiltRating(String playerId) async {
    var allGames = await firestoreService.getVsGamesByPlayerIdOrderedByAscDate(playerId);
    if (allGames.isEmpty) {
      return playerPresetRating;
    } else if (allGames.length <= 5) {
      return await getInitialRating(playerId);
    } else {
      int initialRating = await getInitialRating(playerId);
      int rebuiltRating = initialRating;
      allGames.removeRange(0, minVsGamesToStartRating);
      for (var game in allGames) {
        double score = 0.0;
        int playerRating = 0;
        int oppRating = 0;
        if (game.playerOneId == playerId) {
          playerRating = game.p1Rating;
          oppRating = game.p2Rating;
        } else {
          playerRating = game.p2Rating;
          oppRating = game.p1Rating;
        }
        if (game.winnerId == 'draw') {
          score = 0.5;
        } else if (game.winnerId == playerId) {
          score = 1.0;
        }
        int ratingChange = await getRatingChange(playerRating, oppRating, score);
        rebuiltRating += ratingChange;
      }
      return rebuiltRating;
    }

  }

}