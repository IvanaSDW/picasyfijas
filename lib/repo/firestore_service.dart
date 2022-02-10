import 'package:bulls_n_cows_reloaded/model/player.dart';
import 'package:bulls_n_cows_reloaded/model/time_trial_mode_match.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final logger = Logger();

  CollectionReference get players => firestore.collection(playersTableName);
  // .withConverter<Player>(fromFirestore: (snapshot, _) => Player.fromJson(snapshot.data()!),
  //     toFirestore: (player, _) => player.toJson());
  CollectionReference get ttmMatches =>
      firestore.collection(ttmMatchesTableName);

  Future<void> checkInGoogleUser(User user) async {
    logger.i('called for user: ${user.uid}');
    DocumentReference playerRef = players.doc(user.uid);
    DocumentSnapshot firestoreUser = await playerRef.get();
    UserInfo userInfo = user.providerData[0];

    if (!firestoreUser.exists) {
      //user not yet created in firestore
      logger.i('user not yet in firestore, lets create it...');
      await playerRef.set({
        playerIdFN: user.uid,
        playerNameFN: userInfo.displayName,
        playerIsNewPlayerFN: true,
        playerEmailFN: userInfo.email,
        playerPhoneFN: userInfo.phoneNumber,
        playerGoogleAvatarFN: userInfo.photoURL,
        playerCreatedAtFN: Timestamp.now()
      }).catchError(
              (error) => logger.e("Failed to create user in firestore: $error"));
    } else {
      //user exists in firestore
      logger.i('user already in firestore, lets update it...');
      await playerRef
          .update({
        playerNameFN: userInfo.displayName,
        playerEmailFN: userInfo.email,
        playerPhoneFN: userInfo.phoneNumber,
        playerGoogleAvatarFN: userInfo.photoURL,
      })
          .catchError((error) {
        logger.e("Failed to update user in firestore: $error");});
    }
  }

  Future<void> checkInAnonymousUser(User user) async {
    logger.i('called');
    DocumentReference playerRef = players.doc(user.uid);
    DocumentSnapshot firestoreUser = await playerRef.get();

    if (!firestoreUser.exists) {
      //user not yet created in firestore
      logger.i('user not yet in firestore, lets create it...');
      await playerRef.set({
        playerIdFN: user.uid,
        playerNameFN: 'Guest',
        playerIsNewPlayerFN: true,
        playerCreatedAtFN: Timestamp.now()
      }).then(
              (_) =>
                // logger.i('User created in firestore. Refreshing player object in appController');
                appController.refreshPlayer()

      )
          .catchError(
              (error) => logger.e("Error creating user in firestore: $error")
      );
    } else {
      //user exists in firestore
      logger.i('user already in firestore, lets update it...');
      await playerRef.update({
        playerNameFN: 'Guest',
      }).then(
              (value) => appController.refreshPlayer()
      )
          .catchError(
              (error) => logger.e("Failed to update user in firestore: $error")
      );
    }
  }

  // Future<Player?> getPlayerInfo(String playerId) async {
  //   DocumentSnapshot snapshot =
  //       await players.doc(playerId).get().catchError((error) {
  //     logger.e('Error fetching player data: $error');
  //   });
  //   return snapshot.data() == null ? null : playerFromSnapshot(snapshot);
  // }

  Future<void> deletePlayer(String playerId) async {
    logger.i('called');
    await players
        .doc(playerId)
        .delete()
        .then((value) {logger.i('Player account deleted!');})
        .catchError(
            (error) {logger.e('Error deleting player account: $error');});
  }

  Future<Player> fetchPlayer(String playerId) async {
    logger.i('called for user with id: $playerId');
    final fetchedPlayer = players
        .doc(playerId)
        .withConverter<Player>(
        fromFirestore: (snapshot, _) => Player.fromJson(snapshot.data()!),
        toFirestore: (player, _) => player.toJson());
    // return (
    //     await fetchedPlayer.get()
    //     .catchError((error) {logger.e('Error when fetching player from firestore: $error');})
    // ).data()!;
    Player? player = (await fetchedPlayer.get()
        .catchError((error) {logger.e('Error when fetching player from firestore: $error');})
    ).data();
    if (player == null) {
      logger.wtf('Player may have been deleted from firestore. Exiting...');
      authController.authState = AuthState.signedOut;
      return Player.empty();
    } else {
      return player;
    }
  }

  //
  // TtmMatch? ttmMatchFromSnapshot(DocumentSnapshot matchSnapshot) {
  //   Map<String, dynamic>? data = matchSnapshot.data();
  //   return data == null
  //       ? null
  //       : TtmMatch(
  //           userId: data[PLAYER_ID_FN],
  //           secretNum:
  //               // BandCNumber(data[TTM_MATCH_SECRET_NUM_FN][NUMBER_DIGITS_FN]),
  //               FourDigits.fromData(data[TTM_MATCH_SECRET_NUM_FN][NUMBER_DIGITS_FN]),
  //           moves: data[TTM_MATCH_MOVES_FN].map<MatchMove>((move) {
  //             return MatchMove.fromData(move);
  //           }).toList(),
  //           createdAt: data[TTM_MATCH_CREATED_AT_FN],
  //         );
  // }

  Future<void> falseIsNewPlayer(String playerId) {
    logger.i('Called');
    return players
        .doc(playerId)
        .update({playerIsNewPlayerFN: false}).catchError(
            (error) => logger.e('Error updating isNewPlayer field: $error'));
  }

  Timestamp dateTimeToTimeStamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  DateTime timestampToDate(Timestamp timestamp) {
    return timestamp.toDate();
  }

  // Stream<Player?> playerSnapshots(String playerId) {
  //   return players
  //       .doc(playerId)
  //       .snapshots()
  //       .map((event) => fetchPlayer(event.id));
  // }

  Future<void> saveTtmMatchToFirestore(TtmMatch match) async {
    logger.i('called');
    await ttmMatches
        .add(match.toJson())
        .then((value) => logger
        .i('Successfully saved match to firestore with id: ${value.id}'))
        .catchError(
            (error) => logger.e('Error saving match to firestore: $error'));
  }

  Future<QuerySnapshot?> getTtmMatches(String playerId) async {
    return await ttmMatches
        .where(playerIdFN, isEqualTo: playerId)
        .get()
        .then((value) {
      logger.i('Successfully returned matches: $value');
    }).catchError((error) {
      logger.e('error returning ttm matches: $error');
    });
  }
}
