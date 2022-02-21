import 'package:bulls_n_cows_reloaded/model/player_solo_stats.dart';
import 'package:bulls_n_cows_reloaded/model/solo_match.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerStatsService {

  Query<SoloMatch> soloMatchesQuery(String playerId) =>
      firestore.collection(soloMatchesTableName)
      .where(soloMatchPlayerIdFN, isEqualTo: playerId)
      .orderBy(soloMatchCreatedAtFN, descending: true)
      .withConverter<SoloMatch>(
      fromFirestore: (snapshot, _) => SoloMatch.fromData(snapshot.data()!),
      toFirestore: (soloMatch, _) => soloMatch.toJson());

  Future<List<SoloMatch>> getSoloMatchesById(String playerId) async {
    return await soloMatchesQuery(playerId)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<PlayerSoloStats> calcPlayerStats(String playerId) async {
    double sumOfTime = 0;
    int sumOfGuesses = 0;
    var matches = await getSoloMatchesById(playerId);
    int matchesQty = matches.length;
    for (var match in matches) {
      sumOfTime += match.moves.last.timeStampMillis;
      sumOfGuesses += match.moves.length;
    }

    double timeAverage = matchesQty == 0
        ? 0
        : sumOfTime / matchesQty;

    double guessesAverage = matchesQty == 0
        ? 0
        : sumOfGuesses / matchesQty;

    return PlayerSoloStats(matchesQty, timeAverage, guessesAverage, 0);
  }
}