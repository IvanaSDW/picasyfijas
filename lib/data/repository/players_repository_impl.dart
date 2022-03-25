import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:bulls_n_cows_reloaded/data/repository/players_repository.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlayersRepositoryImpl extends PlayersRepository {
  @override
  Future<void> checkInAnonymousPlayer(User user) async {
    await firestoreService.checkInAnonymousPlayer(user);
  }

  @override
  Future<void> checkInGooglePlayer(User user, bool isVsUnlocked) async {
    await firestoreService.checkInGooglePlayer(user, isVsUnlocked);
  }

  @override
  Future<void> deletePlayer(String playerId) async {
    await firestoreService.deletePlayer(playerId);
  }

  @override
  Future<void> falseIsNewPlayer(String playerId) async {
    await firestoreService.falseIsNewPlayer(playerId);
  }

  @override
  Future<Player?> fetchPlayer(String playerId) async {
    return await firestoreService.fetchPlayer(playerId);
  }

  @override
  Query<Player> playersRankedByGuessesQuery() {
    return firestoreService.playersByGuessesRankQuery();
  }

  @override
  Query<Player> playersRankedByTimeQuery() {
    return firestoreService.playersByTimeRankQuery();
  }

  @override
  Future<int> getPlayerGuessesRank(String playerId) async {
    return await firestoreService.getPlayerTimeRank(playerId);
  }

  @override
  Future<int> getPlayerTimeRank(String playerId) async {
    return await firestoreService.getPlayerGuessesRank(playerId);
  }

}