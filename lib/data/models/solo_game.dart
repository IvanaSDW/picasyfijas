import 'package:bulls_n_cows_reloaded/data/models/game_move.dart';
import 'package:bulls_n_cows_reloaded/data/models/four_digits.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SoloGame {
  String playerId;
  FourDigits? secretNum;
  List<GameMove> moves;
  Timestamp createdAt;

  // factory SoloMatch.fromData(Map<String, dynamic> data)
  //     => SoloMatch(
  //         userId: data[soloMatchPlayerIdFN],
  //         secretNum: FourDigits.fromData(data[soloMatchSecretNumberFN]),
  //         moves: (data[soloMatchMovesFN] as List).map((e) => MatchMove.fromData(e)).toList(),
  //         createdAt: data[soloMatchCreatedAtFN]
  //     );

  SoloGame.fromData(Map<String, dynamic> data)
      : playerId = data[soloGamePlayerIdFN],
        secretNum = data[soloGameSecretNumberFN] == null ? null : FourDigits.fromData(data[soloGameSecretNumberFN]),
        moves = (data[soloGameMovesFN] as List).map((e) => GameMove.fromData(e)).toList(),
        createdAt = data[soloGameCreatedAtFN];

  Map<String, dynamic> toJson() => {
    soloGamePlayerIdFN: playerId,
    soloGameSecretNumberFN: secretNum != null ? secretNum!.toJson() : null,
    soloGameMovesFN: moves.map((move) => move.toJson()).toList(),
    soloGameCreatedAtFN: createdAt,
  };

  SoloGame({
    required this.playerId,
    this.secretNum,
    required this.moves,
    required this.createdAt
  });
}
