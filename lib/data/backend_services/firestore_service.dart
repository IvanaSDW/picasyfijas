import 'package:bulls_n_cows_reloaded/data/ip_locator.dart';
import 'package:bulls_n_cows_reloaded/data/models/four_digits.dart';
import 'package:bulls_n_cows_reloaded/data/models/game_move.dart';
import 'package:bulls_n_cows_reloaded/data/models/player.dart';
import 'package:bulls_n_cows_reloaded/data/models/solo_game.dart';
import 'package:bulls_n_cows_reloaded/data/models/versus_game.dart';
import 'package:bulls_n_cows_reloaded/data/models/versus_game_challenge.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final logger = Logger();
  static FirestoreService instance = Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Collection references
  CollectionReference<Player> get _playersConverted => _firestore.collection(playersTableName)
      .withConverter<Player>(
      fromFirestore: ((snapshot, _) => Player.fromJson(snapshot.data()!)),
      toFirestore: (player, _) => player.toJson()
  );
  CollectionReference get players => _firestore.collection(playersTableName);
  CollectionReference<SoloGame> get soloGames =>
      _firestore.collection(soloGamesTableName)
          .withConverter<SoloGame>(
          fromFirestore: (snapshot, _) => SoloGame.fromData(snapshot.data()!),
          toFirestore: (soloGame, _) => soloGame.toJson()
      );

  CollectionReference get versusGames =>
      _firestore.collection(versusGamesTableName)
          .withConverter<VersusGame>(
          fromFirestore: (snapshot, _) => VersusGame.fromJson(snapshot.data()!),
          toFirestore: (versusGame, _) => versusGame.toJson()
      );

  CollectionReference get versusChallenges =>
      _firestore.collection(versusChallengesTableName)
          .withConverter<VersusGameChallenge>(
          fromFirestore: (snapshot, _) => VersusGameChallenge.fromJson(snapshot.data()!),
          toFirestore: (challenge, _) => challenge.toJson()
      );

  //Player database services
  Query<Player> playersByTimeRankQuery() =>
      _firestore.collection(playersTableName)
          .orderBy(playerTimeAverageFN,)
          .withConverter<Player>(
          fromFirestore: (snapshot, _) => Player.fromJson(snapshot.data()!),
          toFirestore: (player, _) => player.toJson());

  Query<Player> playersByGuessesRankQuery() =>
      _firestore.collection(playersTableName)
          .orderBy(playerGuessesAverageFN,)
          .withConverter<Player>(
          fromFirestore: (snapshot, _) => Player.fromJson(snapshot.data()!),
          toFirestore: (player, _) => player.toJson());

  Query<Player> playersByRatingQuery() =>
      _firestore.collection(playersTableName)
          .where(playerIsRatedFN, isEqualTo: true)
          .orderBy(playerRatingFN, descending: true)
          .limit(100)
          .withConverter<Player>(
          fromFirestore: (snapshot, _) => Player.fromJson(snapshot.data()!),
          toFirestore: (player, _) => player.toJson());

  Future<void> checkInGooglePlayer(User user, bool isVsUnlocked) async {
    DocumentReference playerRef = players.doc(user.uid);
    DocumentSnapshot firestoreUser = await playerRef.get();
    UserInfo userInfo = user.providerData[0];
    if (!firestoreUser.exists) {
      await playerRef.set({
        playerIdFN: user.uid,
        playerNameFN: userInfo.displayName,
        playerIsNewPlayerFN: true,
        playerEmailFN: userInfo.email,
        playerPhoneFN: userInfo.phoneNumber,
        playerGoogleAvatarFN: userInfo.photoURL,
        playerCreatedAtFN: Timestamp.now(),
        playerCountryCodeFN: await IpLocator().getCountryCode(),
        playerIsOnlineFN: true,
        playerIsVsUnlockedFN: isVsUnlocked,
      }).catchError(
              (error) => logger.e("Failed to create user in firestore: $error"));
    } else {
      //user exists in firestore
      await playerRef
          .update({
        playerNameFN: userInfo.displayName,
        playerEmailFN: userInfo.email,
        playerPhoneFN: userInfo.phoneNumber,
        playerGoogleAvatarFN: userInfo.photoURL,
        playerIsOnlineFN: true,
        playerIsVsUnlockedFN: isVsUnlocked,
      })
          .catchError((error) {
        logger.e("Failed to update user in firestore: $error");});
    }
  }

  Future<void> checkInAnonymousPlayer(User user) async {
    DocumentReference playerRef = players.doc(user.uid);
    DocumentSnapshot firestoreUser = await playerRef.get();
    logger.i('looking for player: ${user.uid}, exists = ${firestoreUser.exists}');

    if (!firestoreUser.exists) { //user not yet created in firestore
      await playerRef.set({
        playerIdFN: user.uid,
        playerNameFN: 'guest'.tr,
        playerIsNewPlayerFN: true,
        playerCreatedAtFN: Timestamp.now(),
        playerGuessesAverageFN: double.infinity,
        playerTimeAverageFN: double.infinity,
        playerCountryCodeFN: await IpLocator().getCountryCode(),
        playerIsOnlineFN: true,
        playerRatingFN: playerPresetRating,
        playerIsVsUnlockedFN: false,
      }).then(
              (_) => appController.refreshPlayer()
      )
          .catchError(
              (error) => logger.e("Error creating user in firestore: $error")
      );
    } else {
      //user exists in firestore
      logger.i('user already in firestore, lets update it...');
      await playerRef.update({
        playerNameFN: 'guest'.tr,
        playerIsVsUnlockedFN: false,
      }).then(
              (value) => appController.refreshPlayer()
      )
          .catchError(
              (error) => logger.e("Failed to update user in firestore: $error")
      );
    }
  }

  Future<void> deletePlayer(String playerId) async {
    await players
        .doc(playerId)
        .delete()
        .then((value) {})
        .catchError(
            (error) {logger.e('Error deleting player account: $error');});
  }

  Future<void> updatePlayerSoloAverages(
      String playerId,
      double timeAverage,
      double guessesAverage,
      bool unlockVsMode,
      ) async {
    if(unlockVsMode) {
      await players.doc(playerId).update({
        playerTimeAverageFN: timeAverage,
        playerGuessesAverageFN: guessesAverage,
        playerIsVsUnlockedFN: true,
        playerRatingFN: playerPresetRating,
        playerCountryCodeFN: appController.countryCode, //Use this chance to update locale
      }).then((value) => {appController.refreshPlayer()});
    } else {
      await players.doc(playerId).update({
        playerTimeAverageFN: timeAverage,
        playerGuessesAverageFN: guessesAverage,
        playerCountryCodeFN: appController.countryCode, //Use this chance to update locale
      });
    }
  }

  Future<void> updatePlayerNickName(String playerId, String nickName) async {
    await players.doc(playerId).update({playerNickNameFN: nickName})
        .then((value) {
      appController.refreshNickName(nickName);
    });
  }

  Future<void> addPlayerAvatarUrl(String playerId, String avatarUrl) async {
    await players.doc(playerId).update({playerAddedAvatarsUrlsFN : FieldValue.arrayUnion([avatarUrl])})
        .then((value) {
      appController.refreshPlayer();
    });
  }

  Future<void> updatePlayerVsStats({
    required String playerId,
    required double winRate,
    required int rating,
    required bool isRated,
  }) async {
    await players.doc(playerId).update({
      playerVsModeWinRateFN: winRate,
      playerRatingFN: rating,
      playerIsRatedFN: isRated,
    });
  }

  Future<void> updatePlayerToken({
    required String playerId,
    required String newToken,
  }) async {

    DocumentReference playerRef = players.doc(playerId);
    DocumentSnapshot firestoreUser = await playerRef.get();
    logger.i('looking for player: $playerId, exists = ${firestoreUser.exists}');

    if(firestoreUser.exists) {
      await players.doc(playerId).update(
        {playerPushTokenFN: newToken,
          'tokenTimeStamp': DateTime.now(),},
      );
    }

  }

  Future<void> updateBotPlayerRandomData({
    required Map<String,dynamic> data
  }) async {
    await players.doc(botPlayerDocId).update(data);
  }


  Future<Player?> fetchPlayer(String playerId) async {
    final fetchedPlayer = players
        .doc(playerId)
        .withConverter<Player>(
        fromFirestore: (snapshot, _) => Player.fromJson(snapshot.data()!),
        toFirestore: (player, _) => player.toJson());
    return (await fetchedPlayer.get()
        .catchError((error) {logger.e('Error when fetching player from firestore: $error');})
    ).data();
  }

  Future<bool> nickNameDoesNotExist(String nickName) async {
    logger.i('Called');
    return await _playersConverted.where(playerNickNameFN, isEqualTo: nickName).get()
        .then((value) => value.docs.isEmpty);
  }

  Future<void> falseIsNewPlayer(String playerId) {
    logger.i('Called');
    return players
        .doc(playerId)
        .update({playerIsNewPlayerFN: false}).catchError(
            (error) => logger.e('Error updating isNewPlayer field: $error'));
  }

  Future<int> getPlayerTimeRank(String playerId) async {
    logger.i('called');
    List<Player> orderedByTime = await playersByTimeRankQuery()
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
    logger.i('byTime: ${orderedByTime.length}');
    return orderedByTime.indexWhere((player) => player.id == playerId) + 1;
  }

  Future<int> getPlayerGuessesRank(String playerId) async {
    logger.i('called');
    List<Player> orderedByGuesses = await playersByGuessesRankQuery()
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
    logger.i('byGuesses: ${orderedByGuesses.length}');
    return orderedByGuesses.indexWhere((player) => player.id == playerId) + 1;
  }

  Future<Map<String, dynamic>> getSoloRankings(String playerId) async {

    List<Map<String, dynamic>> soloRankings = await processSoloRankings();

    int timeRank = 0;
    int guessRank = 0;
    int worldRank = 0;

    int playerIndex = soloRankings.indexWhere((element) => element['playerId'] == playerId);
    Map<String, dynamic> playerMap = soloRankings[playerIndex];

    timeRank = playerMap['timeRank'];
    guessRank = playerMap['guessRank'];
    worldRank = playerIndex + 1;

    Map<String, dynamic> soloRanks = {
      'timeRank' : timeRank,
      'guessRank' : guessRank,
      'worldRank' : worldRank,
    };
    return soloRanks;
  }

  Future<List<Map<String, dynamic>>> processSoloRankings() async {
    List<Map<String, dynamic>> soloRanks = <Map<String, dynamic>>[];
    List<Player> orderedByTime = await playersByTimeRankQuery()
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
    List<Player> orderedByGuesses = await playersByGuessesRankQuery()
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());

    for (Player player in orderedByTime) {
      int timeRank = orderedByTime.indexWhere((element) => element.id == player.id);
      int guessRank = orderedByGuesses.indexWhere((element) => element.id == player.id);
      int sumOfRank = timeRank + guessRank;
      soloRanks.add({'playerId' : player.id, 'player' : player, 'timeRank' : timeRank, 'guessRank' : guessRank, 'sumOfRank' : sumOfRank});
    }

    soloRanks.sort((a, b) => a['sumOfRank'].compareTo(b['sumOfRank']));
    return soloRanks;

  }

  Future<List<Player>> getSoloLeaderboard() async {
    List<Player> allPlayersLeaderBoard = <Player>[];
    List<Player> onlyGoogle = <Player>[];
    List<Player> withoutInfinities = <Player>[];
    // List<Player> soloLeaderBoard = <Player>[];
    List<Map<String, dynamic>> soloRanks = await processSoloRankings();
    for (Map<String, dynamic> element in soloRanks) {
      allPlayersLeaderBoard.add(element['player']);
    }

    onlyGoogle = allPlayersLeaderBoard.where((player) => player.email != null).toList();
    withoutInfinities = onlyGoogle.where((player) => player.soloTimeAverage != double.infinity).toList();
    return withoutInfinities;
  }

  Future<List<Player>> getVsLeaderboard() async {
    return await playersByRatingQuery()
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<Map<String, dynamic>> getPlayerRatingRank(String playerId) async {
    List<Player> orderedByRating = await getVsLeaderboard();
    int rankIndex = orderedByRating.indexWhere((player) => player.id == playerId) + 1;
    double percentile = (orderedByRating.length- rankIndex) / orderedByRating.length;
    return {'rank' : rankIndex, 'percentile' : percentile};
  }

  //SoloGames database services
  Query<SoloGame> soloGamesByPlayerIdQuery(String playerId) =>
      _firestore.collection(soloGamesTableName)
          .where(soloGamePlayerIdFN, isEqualTo: playerId)
          .orderBy(soloGameCreatedAtFN, descending: true)
          .withConverter<SoloGame>(
          fromFirestore: (snapshot, _) => SoloGame.fromData(snapshot.data()!),
          toFirestore: (soloMatch, _) => soloMatch.toJson());

  Future<List<SoloGame>> getSoloGamesByPlayerId(String playerId) async {
    return await soloGamesByPlayerIdQuery(playerId)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<List<SoloGame>> getLastThousandSoloGames() async {
    return await lastThousandSoloGames().get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Query<SoloGame> lastThousandSoloGames() =>
      soloGames.orderBy(soloGameCreatedAtFN, descending: true).limit(1000);

  Query<SoloGame> soloGamesBySecretNumberQuery(FourDigits secretNumber) =>
      _firestore.collection(soloGamesTableName)
          .where(soloGameSecretNumberFN, isEqualTo: secretNumber)
          .withConverter<SoloGame>(
          fromFirestore: (snapshot, _) => SoloGame.fromData(snapshot.data()!),
          toFirestore: (soloMatch, _) => soloMatch.toJson());

  Future<List<SoloGame>> getSoloGamesWhereSecretNumber(FourDigits number) async {
    return await soloGamesBySecretNumberQuery(number)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<void> moveOldIdSoloGames(String oldId, String newId) async {
    _firestore.collection(soloGamesTableName)
        .where(soloGamePlayerIdFN, isEqualTo: oldId)
        .get()
        .then((value) => {
      for (var doc in value.docs) {
        doc.reference.update({soloGamePlayerIdFN : newId})
      }

    });
  }

  Future<DocumentReference<SoloGame>> addSoloGame(SoloGame match) async {
    return await soloGames.add(match)
        .then((value) => value)
        .catchError((error) {
    });
  }

  //Versus Challenges database services
  Query<VersusGameChallenge> versusChallengesOrderedByDate() =>
      _firestore.collection(versusChallengesTableName)
          .where(versusChallengeOpponentIdFN, isNull: true)
          .where(versusChallengeChallengerIdFN, isNotEqualTo: auth.currentUser!.uid)
          .orderBy(versusChallengeChallengerIdFN)
          .orderBy(versusChallengeCreatedAtFN)
          .withConverter(
          fromFirestore: (snapshot, _) => VersusGameChallenge.fromJson(snapshot.data()!),
          toFirestore: (versusChallenge, _) => versusChallenge.toJson()
      );

  Future<List<QueryDocumentSnapshot<VersusGameChallenge>>> getVersusChallengesQueue() async {
    return await versusChallengesOrderedByDate()
        .get()
        .then((value) => value.docs);
  }

  Future<QueryDocumentSnapshot<VersusGameChallenge>?> getOldestVersusChallenge() async {
    return await getVersusChallengesQueue()
        .then((challenges) => challenges.isEmpty ? null : challenges.first);
  }

  Future<DocumentReference<VersusGameChallenge>> postVersusChallenge(VersusGameChallenge challenge) async {
    return await versusChallenges.add(challenge)
        .then((value) {
      addVsGameToCount();
      return value as DocumentReference<VersusGameChallenge>;
    });
  }

  Future<void> deleteVersusChallenge(String challengeId) async {
    await versusChallenges.doc(challengeId).delete();
  }

  Future<void> updateVersusChallenge(DocumentReference challengeReference, Map<String, dynamic> data) async {
    await challengeReference.update(data);
  }

  //Versus Games Database services
  Query<VersusGame> vsGamesQueryByPlayerIdOrderByAscDate(String playerId) =>
      _firestore.collection(versusGamesTableName)
          .where(playerId, whereIn: [versusGamePlayerOneIdFN, versusGamePlayerTwoIdFN])
          .orderBy(versusGameCreatedAtFN, descending: true)
          .withConverter<VersusGame>(
          fromFirestore: (snapshot, _) => VersusGame.fromJson(snapshot.data()!),
          toFirestore: (vsGame, _) => vsGame.toJson());

  Query<VersusGame> vsGamesQueryOrderedByAscDate() =>
      _firestore.collection(versusGamesTableName)
          .orderBy(versusGameCreatedAtFN, descending: true)
          .withConverter<VersusGame>(
          fromFirestore: (snapshot, _) => VersusGame.fromJson(snapshot.data()!),
          toFirestore: (vsGame, _) => vsGame.toJson());

  Future<List<VersusGame>> getVsGamesByPlayerIdOrderedByAscDate(String playerId) async {
    return await vsGamesQueryByPlayerIdOrderByAscDate(playerId).get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Query<VersusGame> initialVsGamesQueryByPlayerId(String playerId) =>
      _firestore.collection(versusGamesTableName)
          .where(playerId, whereIn: [versusGamePlayerOneIdFN, versusGamePlayerTwoIdFN])
          .orderBy(versusGameCreatedAtFN)
          .limit(minVsGamesToStartRating)
          .withConverter<VersusGame>(
          fromFirestore: (snapshot, _) => VersusGame.fromJson(snapshot.data()!),
          toFirestore: (vsGame, _) => vsGame.toJson());

  Future<List<VersusGame>> getInitialVsGamesByPlayerId(String playerId) async {
    return await initialVsGamesQueryByPlayerId(playerId).get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Query<VersusGame> vsGamesByPlayerOneIdQuery(String playerId) =>
      _firestore.collection(versusGamesTableName)
          .where(versusGamePlayerOneIdFN, isEqualTo: playerId)
          .withConverter<VersusGame>(
          fromFirestore: (snapshot, _) => VersusGame.fromJson(snapshot.data()!),
          toFirestore: (vsGame, _) => vsGame.toJson());

  Query<VersusGame> vsGamesByPlayerTwoIdQuery(String playerId) =>
      _firestore.collection(versusGamesTableName)
          .where(versusGamePlayerTwoIdFN, isEqualTo: playerId)
          .withConverter<VersusGame>(
          fromFirestore: (snapshot, _) => VersusGame.fromJson(snapshot.data()!),
          toFirestore: (vsGame, _) => vsGame.toJson());

  Future<List<VersusGame>> getVsGamesWherePlayer1(String playerId) async {
    return await vsGamesByPlayerOneIdQuery(playerId).get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<List<VersusGame>> getVsGamesWherePlayer2(String playerId) async {
    return await vsGamesByPlayerTwoIdQuery(playerId).get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<DocumentReference<VersusGame>> addVersusGame(VersusGame game) async {
    return await versusGames.add(game)
        .then((value) => value as DocumentReference<VersusGame>);
  }

  Future<void> addPlayerOneSecretNumberToVersusGame(String gameId, FourDigits secretNumber ) async {
    versusGames.doc(gameId).update({'$versusGamePlayerOneMatchFN.$soloGameSecretNumberFN': secretNumber.toJson()});
  }

  Future<void> addPlayerTwoSecretNumberToVersusGame(String gameId, FourDigits secretNumber ) async {
    versusGames.doc(gameId).update({'$versusGamePlayerTwoMatchFN.$soloGameSecretNumberFN': secretNumber.toJson()});
  }

  Future<void> removePlayerOneMoveInVersusGame(DocumentReference gameReference, int index) async  {
    String playerOneMovesFieldName = '$versusGamePlayerOneMatchFN.$soloGameMovesFN';
    await gameReference.update({playerOneMovesFieldName : FieldValue.arrayRemove([index.toString()])})
        .catchError((error) {
    });
  }

  Future<void> addMoveToPlayerOneInVersusGame(DocumentReference gameReference, GameMove move) async {
    gameReference.update({
      '$versusGamePlayerOneMatchFN.$soloGameMovesFN' : FieldValue.arrayUnion([move.toJson()]),
      versusGameWhoIsToMoveFN: VersusPlayer.player2.name
    });
  }

  Future<void> addMoveToPlayerTwoInVersusGame(DocumentReference gameReference, GameMove move) async {
    gameReference.update({
      '$versusGamePlayerTwoMatchFN.$soloGameMovesFN' : FieldValue.arrayUnion([move.toJson()]),
      versusGameWhoIsToMoveFN: VersusPlayer.player1.name
    });
  }

  Future<void> addLastMoveToPlayerTwoInVersusGame(DocumentReference gameReference, GameMove move) async {
    gameReference.update({
      '$versusGamePlayerTwoMatchFN.$soloGameMovesFN' : FieldValue.arrayUnion([move.toJson()]),
      versusGameWhoIsToMoveFN: VersusPlayer.none.name,
    });
  }

  Future<void> addFinalMoveToPlayerOneInVersusGame({
    required DocumentReference gameReference,
    required GameMove move,
    required int totalMoves,
  }) async {
    gameReference.update({
      '$versusGamePlayerOneMatchFN.$soloGameMovesFN' : FieldValue.arrayUnion([move.toJson()]),
      versusGameWhoIsToMoveFN: VersusPlayer.player2.name,
      versusGamePlayerOneFoundFN: totalMoves,
    });
  }

  Future<void> addFinalMoveToPlayerTwoInVersusGame({
    required DocumentReference gameReference,
    required GameMove move,
    int? totalMoves,
    required WinnerPlayer winnerPlayer,
    required WinByMode winByMode,
    required String winnerId,
  }) async {
    gameReference.update({
      '$versusGamePlayerTwoMatchFN.$soloGameMovesFN' : FieldValue.arrayUnion([move.toJson()]),
      versusGameWhoIsToMoveFN: VersusPlayer.unknown.name,
      versusGamePlayerTwoFoundFN: totalMoves,
      versusGameWinnerPlayerFN: winnerPlayer.name,
      versusGameWinByModeFN: winByMode.name,
      versusGameStatusFN: VersusGameStatus.finished.name,
      versusGameWinnerIdFN: winnerId,
    });
  }

  Future<void> addFinalResultToVersusGame({
    required DocumentReference gameReference,
    required WinnerPlayer winnerPlayer,
    required WinByMode winByMode,
    required String winnerId,
  }) async {
    gameReference.update({
      versusGameWinnerPlayerFN: winnerPlayer.name,
      versusGameWinByModeFN: winByMode.name,
      versusGameStatusFN: VersusGameStatus.finished.name,
      versusGameWinnerIdFN: winnerId,
    });
  }

  Future<void> updateVersusGameStatus(DocumentReference gameReference, VersusGameStatus status) async {
    await gameReference.update({versusGameStatusFN: status.name});
  }

//App globals Database services
  Future<void> reportOnline() async {
    _playersConverted.doc(auth.currentUser!.uid).get().then((value) => {
      if (!value.data()!.isOnline!) _firestore.collection(appGlobalsTableName).doc(appGlobalsGeneralInfoDN)
          .update({appGlobalsOnLineCountFN: FieldValue.increment(1)})
          .then((value) => _playersConverted.doc(auth.currentUser!.uid).update({
        playerIsOnlineFN: true}))
    });
  }

  Future<void> reportOffline() async {
    _firestore.collection(appGlobalsTableName).doc(appGlobalsGeneralInfoDN)
        .update({appGlobalsOnLineCountFN: FieldValue.increment(-1)});
    players.doc(auth.currentUser!.uid).update({playerIsOnlineFN: false});
  }

  Future<void> addVsGameToCount() async {
    _firestore.collection(appGlobalsTableName).doc(appGlobalsGeneralInfoDN)
        .update({appGlobalsVersusGamesCountFN: FieldValue.increment(1)});
  }

  Future<void> removeVsGameFromCount() async {
    _firestore.collection(appGlobalsTableName).doc(appGlobalsGeneralInfoDN)
        .update({appGlobalsVersusGamesCountFN: FieldValue.increment(-1)});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> appGeneralInfo() =>
      _firestore.collection(appGlobalsTableName).doc(appGlobalsGeneralInfoDN).snapshots();

  //Settings database services:
  Future<String?> fetchPlayStoreDynamicLink() async {
    String? link;
    await _firestore.collection(appGlobalsTableName).doc(appGlobalsSettingsDN)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data() != null) {
          link = value.data()![appSettingsPlayStoreDynamicLinkFN];
        }
      }
    });
    logger.i('Returning link: $link');
    return link;
  }

}
