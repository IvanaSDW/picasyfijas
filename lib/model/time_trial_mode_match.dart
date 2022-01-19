import 'package:bulls_n_cows_reloaded/model/match_move.dart';
import 'package:bulls_n_cows_reloaded/model/four_digits.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';

class TtmMatch {
  String userId;
  FourDigits secretNum;
  List<MatchMove> moves;
  DateTime createdAt;

  TtmMatch.fromData(Map<String, dynamic> data)
      : userId = data[ttmMatchPlayerIdFN],
        secretNum = data[ttmMatchSecretNumberFN],
        moves = data[ttmMatchMovesFN],
        createdAt = data[ttmMatchCreatedAtFN];

  Map<String, dynamic> toJson() => {
        ttmMatchPlayerIdFN: userId,
        ttmMatchSecretNumberFN: secretNum.toJson(),
        ttmMatchMovesFN: moves.map((e) => e.toJson()).toList(),
        ttmMatchCreatedAtFN: createdAt,
      };

  TtmMatch({
    required this.userId,
    required this.secretNum,
    required this.moves,
    required this.createdAt
  });
}
