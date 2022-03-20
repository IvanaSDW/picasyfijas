import 'package:bulls_n_cows_reloaded/data/models/solo_game.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VersusGame {
  String playerOneId;
  String playerTwoId;
  SoloGame playerOneGame;
  SoloGame playerTwoGame;
  int p1Rating;
  int p2Rating;
  VersusPlayer whoIsToMove;
  Timestamp createdAt;
  VersusGameStatus state;
  int? playerOneFound;
  int? playerTwoFound;
  String? winnerId;
  WinnerPlayer? winnerPlayer;
  WinByMode? winByMode;

  VersusGame({
    required this.playerOneId,
    required this.playerTwoId,
    required this.playerOneGame,
    required this.playerTwoGame,
    required this.p1Rating,
    required this.p2Rating,
    required this.whoIsToMove,
    required this.createdAt,
    required this.state,
    this.playerOneFound,
    this.playerTwoFound,
    this.winnerId,
    this.winnerPlayer,
    this.winByMode,
  });

  factory VersusGame.fromJson(Map<String, dynamic> json) =>
      VersusGame(
        playerOneId: json[versusGamePlayerOneIdFN],
        playerTwoId: json[versusGamePlayerTwoIdFN],
        playerOneGame: SoloGame.fromData(json[versusGamePlayerOneMatchFN]),
        playerTwoGame: SoloGame.fromData(json[versusGamePlayerTwoMatchFN]),
        p1Rating: json[vsGameP1RatingFN],
        p2Rating: json[vsGameP1RatingFN],
        whoIsToMove: (json[versusGameWhoIsToMoveFN] as String).toPlayerToMove(),
        createdAt: json[versusGameCreatedAtFN],
        state: (json[versusGameStatusFN] as String).toMatchState(),
        playerOneFound: json[versusGamePlayerOneFoundFN],
        playerTwoFound: json[versusGamePlayerTwoFoundFN],
        winnerId: json[versusGameWinnerIdFN],
        winnerPlayer: json[versusGameWinnerPlayerFN] == null ? null
            : (json[versusGameWinnerPlayerFN] as String).toWinnerPlayer(),
        winByMode: json[versusGameWinByModeFN] == null ? null
            : (json[versusGameWinByModeFN] as String).toWinByMode(),
      );

  Map<String, dynamic> toJson() => {
    versusGamePlayerOneIdFN: playerOneId,
    versusGamePlayerTwoIdFN: playerTwoId,
    versusGamePlayerOneMatchFN: playerOneGame.toJson(),
    versusGamePlayerTwoMatchFN: playerTwoGame.toJson(),
    vsGameP1RatingFN: p1Rating,
    vsGameP2RatingFN: p2Rating,
    versusGameWhoIsToMoveFN: whoIsToMove.name,
    versusGameCreatedAtFN: createdAt,
    versusGameStatusFN: state.name,
    versusGamePlayerOneFoundFN: playerOneFound,
    versusGamePlayerTwoFoundFN: playerTwoFound,
    versusGameWinnerIdFN: winnerId,
    versusGameWinnerPlayerFN: winnerPlayer == null ? null : winnerPlayer!.name,
    versusGameWinByModeFN: winByMode == null ? null : winByMode!.name,
  };
}

extension on String {
  VersusGameStatus toMatchState() {
    for (VersusGameStatus state in VersusGameStatus.values) {
      if (state.name == this) {
        return state;
      }
    }
    return VersusGameStatus.unknown;
  }
}

extension on String {
  VersusPlayer toPlayerToMove() {
    for (VersusPlayer player in VersusPlayer.values) {
      if (player.name == this) {
        return player;
      }
    }
    return VersusPlayer.unknown;
  }
}

extension on String {
  WinnerPlayer toWinnerPlayer() {
    for (WinnerPlayer player in WinnerPlayer.values) {
      if (player.name == this) {
        return player;
      }
    }
    return WinnerPlayer.unknown;
  }
}

extension on String {
  WinByMode toWinByMode() {
    for (WinByMode mode in WinByMode.values) {
      if (mode.name == this) {
        return mode;
      }
    }
    return WinByMode.unknown;
  }
}