import 'package:bulls_n_cows_reloaded/data/models/versus_game_challenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class VersusChallengesRepository {

  Future<DocumentReference<VersusGameChallenge>> postVersusChallenge(VersusGameChallenge challenge);

  Future<QueryDocumentSnapshot<VersusGameChallenge>?> getOldestVersusChallenge();

  Future<void> deleteChallenge(String challengeId);

  Future<List<QueryDocumentSnapshot<VersusGameChallenge>>> getVersusChallengeQueue();

  Future<void> updateVersusChallenge(DocumentReference challengeReference, Map<String, dynamic> data);
}