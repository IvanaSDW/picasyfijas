import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VersusGameChallenge {
  String playerOneId;
  int p1Rating;
  String? playerTwoId;
  int? p2Rating;
  String? assignedGameId;
  Timestamp createdAt;

  VersusGameChallenge({
    required this.playerOneId,
    required this.p1Rating,
    this.playerTwoId,
    this.p2Rating,
    this.assignedGameId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    versusChallengeChallengerIdFN: playerOneId,
    vsChallengeP1RatingFN: p1Rating,
    versusChallengeOpponentIdFN: playerTwoId,
    vsChallengeP2RatingFN: p2Rating,
    versusChallengeAssignedGameIdFN: assignedGameId,
    versusChallengeCreatedAtFN: createdAt,
  };

  factory VersusGameChallenge.fromJson(Map<String, dynamic> json)
  => VersusGameChallenge(
    playerOneId: json[versusChallengeChallengerIdFN],
    p1Rating: json[vsChallengeP1RatingFN],
    playerTwoId: json[versusChallengeOpponentIdFN],
    p2Rating: json[vsChallengeP2RatingFN],
    assignedGameId: json[versusChallengeAssignedGameIdFN],
    createdAt: json[versusChallengeCreatedAtFN],
  );
}