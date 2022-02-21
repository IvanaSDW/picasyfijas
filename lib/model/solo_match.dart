import 'package:bulls_n_cows_reloaded/model/match_move.dart';
import 'package:bulls_n_cows_reloaded/model/four_digits.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SoloMatch {
  String playerId;
  FourDigits secretNum;
  List<MatchMove> moves;
  Timestamp createdAt;

  // factory SoloMatch.fromData(Map<String, dynamic> data)
  //     => SoloMatch(
  //         userId: data[soloMatchPlayerIdFN],
  //         secretNum: FourDigits.fromData(data[soloMatchSecretNumberFN]),
  //         moves: (data[soloMatchMovesFN] as List).map((e) => MatchMove.fromData(e)).toList(),
  //         createdAt: data[soloMatchCreatedAtFN]
  //     );

  SoloMatch.fromData(Map<String, dynamic> data)
      : playerId = data[soloMatchPlayerIdFN],
        secretNum = FourDigits.fromData(data[soloMatchSecretNumberFN]),
        moves = (data[soloMatchMovesFN] as List).map((e) => MatchMove.fromData(e)).toList(),
        createdAt = data[soloMatchCreatedAtFN];

  Map<String, dynamic> toJson() => {
    soloMatchPlayerIdFN: playerId,
    soloMatchSecretNumberFN: secretNum.toJson(),
    soloMatchMovesFN: moves.map((move) => move.toJson()).toList(),
    soloMatchCreatedAtFN: createdAt,
  };

  SoloMatch({
    required this.playerId,
    required this.secretNum,
    required this.moves,
    required this.createdAt
  });
}
