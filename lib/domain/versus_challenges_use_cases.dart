import 'package:bulls_n_cows_reloaded/data/models/versus_game_challenge.dart';
import 'package:bulls_n_cows_reloaded/data/repository/versus_challenges_repository_impl.dart';
import 'package:bulls_n_cows_reloaded/domain/players_use_cases.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/repository/versus_challenges_repository.dart';

class PostNewChallengeUC {
  final VersusChallengesRepository _repository = VersusChallengeRepositoryImpl();

  Future<DocumentReference<VersusGameChallenge>> call(VersusGameChallenge challenge) async {
    return await _repository.postVersusChallenge(challenge);
  }
}

class FindChallengeUC {
  final VersusChallengesRepository _repository = VersusChallengeRepositoryImpl();

  Future<QueryDocumentSnapshot<VersusGameChallenge>?> call() async {
    return await _repository.getOldestVersusChallenge();
  }
}

class AcceptVersusChallengeUC {
  final VersusChallengesRepository _repository = VersusChallengeRepositoryImpl();
  Future<void> call(DocumentReference challengeReference, String acceptedById) async {
    await _repository.updateVersusChallenge(challengeReference,
        {versusChallengeOpponentIdFN: acceptedById, vsChallengeP2RatingFN: appController.currentPlayer.rating}
    );
  }
}

class AcceptVersusChallengeAsBotUC {
  final VersusChallengesRepository _repository = VersusChallengeRepositoryImpl();
  Future<void> call(DocumentReference challengeReference, String acceptedById) async {
    await FetchPlayerByIdUC().call(acceptedById).then((botData) async {
      await _repository.updateVersusChallenge(challengeReference,
          {versusChallengeOpponentIdFN: acceptedById, vsChallengeP2RatingFN: botData?.rating}
      );
    });
  }
}

class AssignGameToVersusChallengeUC {
  final VersusChallengesRepository _repository = VersusChallengeRepositoryImpl();
  Future<void> call({required DocumentReference challengeReference, required String gameId}) async {
    await _repository.updateVersusChallenge(challengeReference, {versusChallengeAssignedGameIdFN: gameId});
  }
}

class CancelPostedVersusChallengeUC {
  final VersusChallengesRepository _repository = VersusChallengeRepositoryImpl();
  Future<void> call({required String challengeId}) async {
    await _repository.deleteChallenge(challengeId);
  }
}
