import 'package:bulls_n_cows_reloaded/model/player.dart';
import 'package:bulls_n_cows_reloaded/model/solo_match.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final logger = Logger();

  CollectionReference get players => firestore.collection(playersTableName);
  CollectionReference get soloMatches =>
      firestore.collection(soloMatchesTableName)
          .withConverter<SoloMatch>(
          fromFirestore: (snapshot, _) => SoloMatch.fromData(snapshot.data()!),
          toFirestore: (ttmMatch, _) => ttmMatch.toJson()
      );

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

  Future<void> moveOldIdSoloMatches(String oldId, String newId) async {
    logger.i('called to move matches from $oldId to $newId');
    firestore.collection(soloMatchesTableName)
        .where(soloMatchPlayerIdFN, isEqualTo: oldId)
        .get()
        .then((value) => {
    for (var doc in value.docs) {
        doc.reference.update({soloMatchPlayerIdFN : newId})
  }
    });
  }

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
      appController.needLand = true;
      authController.signOut();
      return Player.empty();
    } else {
      return player;
    }
  }

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

  Future<void> saveSoloMatchToFirestore(SoloMatch match) async {
    logger.i('called with object: ${match.toJson()}');
    await soloMatches.add(match)
        .then((value) => logger.i('Successfully saved match to firestore with id: ${value.id}'))
        .catchError((error) => logger.e('Error saving match to firestore: $error'));
  }

}
