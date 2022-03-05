import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VersusGameChallenge {
  String playerOneId;
  String? playerTwoId;
  String? assignedGameId;
  Timestamp createdAt;

  VersusGameChallenge({
    required this.playerOneId,
    this.playerTwoId,
    this.assignedGameId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    versusChallengeChallengerIdFN: playerOneId,
    versusChallengeOpponentIdFN: playerTwoId,
    versusChallengeAssignedGameIdFN: assignedGameId,
    versusChallengeCreatedAtFN: createdAt,
  };

  factory VersusGameChallenge.fromJson(Map<String, dynamic> json)
  => VersusGameChallenge(
    playerOneId: json[versusChallengeChallengerIdFN],
    playerTwoId: json[versusChallengeOpponentIdFN],
    assignedGameId: json[versusChallengeAssignedGameIdFN],
    createdAt: json[versusChallengeCreatedAtFN],
  );
}