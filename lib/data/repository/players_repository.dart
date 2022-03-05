import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PlayersRepository {

  Future<void> checkInGooglePlayer(User user);

  Future<void> checkInAnonymousPlayer(User user);

  Future<void> deletePlayer(String playerId);

  Future<void> updatePlayerAverages(String playerId, double timeAverage, double guessesAverage);

  Future<Player?> fetchPlayer(String playerId);

  Future<void> falseIsNewPlayer(String playerId);

  Future<int> getPlayerTimeRank(String playerId);

  Future<int> getPlayerGuessesRank(String playerId);

  Query<Player> playersRankedByTimeQuery();

  Query<Player> playersRankedByGuessesQuery();

}