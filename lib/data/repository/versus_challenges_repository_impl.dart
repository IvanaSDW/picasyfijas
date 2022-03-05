import 'package:bulls_n_cows_reloaded/data/models/versus_game_challenge.dart';
import 'package:bulls_n_cows_reloaded/data/repository/versus_challenges_repository.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VersusChallengeRepositoryImpl extends VersusChallengesRepository {

  @override
  Future<void> deleteChallenge(String challengeId) async {
    await firestoreService.deleteVersusChallenge(challengeId);
  }

  @override
  Future<QueryDocumentSnapshot<VersusGameChallenge>?> getOldestVersusChallenge() async {
    return await firestoreService.getOldestVersusChallenge();
  }

  @override
  Future<List<QueryDocumentSnapshot<VersusGameChallenge>>> getVersusChallengeQueue() async {
    return await firestoreService.getVersusChallengesQueue();
  }

  @override
  Future<DocumentReference<VersusGameChallenge>> postVersusChallenge(VersusGameChallenge challenge) async {
    return await firestoreService.postVersusChallenge(challenge)
        .then((value) => value);
  }

  @override
  Future<void> updateVersusChallenge(DocumentReference challengeReference, Map<String, dynamic> data) async {
    await firestoreService.updateVersusChallenge(challengeReference, data);
  }



}