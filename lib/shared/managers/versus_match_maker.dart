import 'dart:async';

import 'package:bulls_n_cows_reloaded/data/models/versus_game.dart';
import 'package:bulls_n_cows_reloaded/data/models/versus_game_challenge.dart';
import 'package:bulls_n_cows_reloaded/domain/versus_challenges_use_cases.dart';
import 'package:bulls_n_cows_reloaded/domain/versus_games_use_cases.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/game_move.dart';
import '../../data/models/solo_game.dart';

class VersusMatchMaker {

  late StreamSubscription _acceptedChallengeStream;
  late StreamSubscription _postedChallengeStream;

  late DocumentReference<VersusGameChallenge> acceptedChallengeReference;
  late DocumentReference<VersusGameChallenge> postedChallengeReference;

  final PostNewChallengeUC _postNewChallenge = PostNewChallengeUC();
  final FindChallengeUC _findChallenge = FindChallengeUC();
  final AcceptVersusChallengeUC _acceptVersusChallenge = AcceptVersusChallengeUC();
  final CreateVersusGameUC _createVersusGame = CreateVersusGameUC();
  final AssignGameToVersusChallengeUC _assignGameToChallenge = AssignGameToVersusChallengeUC();
  final CancelPostedVersusChallengeUC _cancelPostedChallenge = CancelPostedVersusChallengeUC();

  void Function(
      Stream<DocumentSnapshot<VersusGame>> stream,
      DocumentReference<VersusGame> gameReference,
      bool isPlayerOne,
      )? _onGameCreated;

  void onGameCreated(
      Function(Stream<DocumentSnapshot<VersusGame>> stream,
          DocumentReference<VersusGame> gameReference,
          bool isPlayerOne,
          ) callback) {
    _onGameCreated = callback;
  }

  void makeMatch({required String playerId}) async {
    await _findChallenge().then((snapshot) async {
      if (snapshot == null) {
        _postChallenge(
            challenge: VersusGameChallenge(
              playerOneId: playerId,
              createdAt: Timestamp.now(),
            )
        );
      } else {
        acceptedChallengeReference = snapshot.reference;
        _acceptVersusChallenge(snapshot.reference, playerId)
            .then((value) => _subscribeToAcceptedChallenge(challengeReference: acceptedChallengeReference));
      }
    });
  }

  void _postChallenge({required VersusGameChallenge challenge,}) async {
    await _postNewChallenge(challenge)
        .then((value) {
      _subscribeToPostedChallenge(value);
    });
  }

  void _subscribeToPostedChallenge(DocumentReference<VersusGameChallenge> reference) {
    _postedChallengeStream = reference.snapshots().listen((event) async {
      postedChallengeReference = event.reference;
      VersusGameChallenge? challenge = event.data();
      if( challenge != null) {
        logger.i('received challenge update: ${challenge.toJson()}');
        if(challenge.playerTwoId != null) {
          logger.i('Challenge accepted, we are player 1, creating game...');
          _postedChallengeStream.cancel();
          await _createGame(challenge: challenge)
              .then((value) async {
            await _assignGameToChallenge(challengeReference: postedChallengeReference, gameId: value.id);
            var gameStream = _subscribeToVersusGameRef(value);
            if (_onGameCreated != null) _onGameCreated!(gameStream, value, true);
          });
        }
      } else {
        logger.i('Received a null snapshot from challenge subscription');
        Get.snackbar('Game canceled', 'game was canceled', backgroundColor: Colors.green);
        Future.delayed(const Duration(milliseconds: 1000), () => Get.back(closeOverlays: true));
      }
    });
    logger.i('Listening to posted challenge : ${reference.id}');
  }


  Future<DocumentReference<VersusGame>> _createGame({required VersusGameChallenge challenge}) async {
    logger.i('called');
    VersusGame newGame = VersusGame(
        playerOneId: challenge.playerOneId,
        playerTwoId: challenge.playerTwoId!,
        playerOneGame: SoloGame(
          playerId: challenge.playerOneId,
          moves: <GameMove>[],
          createdAt: Timestamp.now(),
        ),
        playerTwoGame: SoloGame(
          playerId: challenge.playerTwoId!,
          moves: <GameMove>[],
          createdAt: Timestamp.now(),
        ),
        whoIsToMove: VersusPlayer.player1,
        createdAt: Timestamp.now(),
        state: VersusGameStatus.created
    );
    return await _createVersusGame(newGame)
        .then((value) => value);
  }

  void _subscribeToAcceptedChallenge({required DocumentReference<VersusGameChallenge> challengeReference}) {
    _acceptedChallengeStream = challengeReference.snapshots().listen((event) {
      VersusGameChallenge? challenge = event.data();
      if( challenge != null) {
        logger.i('Received a snapshot from challenge subscription : ${challenge.toJson()}');
        if(challenge.assignedGameId != null) { //Game is created by challenger player, we are player 2
          logger.i('Received an assigned game: ${challenge.assignedGameId}, we are player 2');
          _acceptedChallengeStream.cancel();
          challengeReference.delete();
          var gameStream = _subscribeToVersusGameId(challenge.assignedGameId!);
          if (_onGameCreated != null) {
            _onGameCreated!(
              gameStream,
              firestoreService.versusGames.doc(challenge.assignedGameId) as DocumentReference<VersusGame>,
              false,
            );
          }
        }
      } else {
        logger.i('Received a null snapshot from challenge subscription');
      }
    });
  }

  Stream<DocumentSnapshot<VersusGame>> _subscribeToVersusGameRef(DocumentReference<VersusGame> gameReference) {
    logger.i('called to subscribe to game id: ${gameReference.id}');
    _postedChallengeStream.cancel();
    return gameReference.snapshots();
  }

  Stream<DocumentSnapshot<VersusGame>> _subscribeToVersusGameId(String gameId) {
    logger.i('called to subscribe to game id: $gameId');
    _acceptedChallengeStream.cancel();
    return firestoreService.versusGames.doc(gameId).snapshots() as Stream<DocumentSnapshot<VersusGame>>;
  }

  void cancelPostedChallenge(DocumentReference<VersusGameChallenge> reference) {
    _cancelPostedChallenge;
  }

  void cancelChallenge() {
    logger.i('called');
    Object? error;
    try {
      acceptedChallengeReference.delete();
    } catch (e) {
      error = e;
      logger.e('error deleting accepted challenge from queue: $e');
    }
    try {
      postedChallengeReference.delete();
      error = null;
    } catch (e) {
      error = e;
      logger.e('error deleting posted challenge from queue: $e');
    }
    if (error != null) {
      Get.back();
    } else {
      logger.i('Removing game from gameCount in firestore...');
      firestoreService.removeVsGameFromCount();
    }
  }

}