import 'package:bulls_n_cows_reloaded/data/models/versus_game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class VersusGamesRepository {
  Future<DocumentReference<VersusGame>> createVersusGame(VersusGame game);

}