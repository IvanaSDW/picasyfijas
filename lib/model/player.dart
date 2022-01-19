
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? photoUrl;
  bool? isNewPlayer = true;
  DateTime? createdAt;

  Player({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.isNewPlayer,
    required this.createdAt
  });

  Player.empty();

  Map<String, dynamic> toJson() => {
    playerIdFN: id,
    playerNameFN: name,
    playerEmailFN: email,
    playerPhoneFN: phone,
    playerGoogleAvatarFN: photoUrl,
    playerIsNewPlayerFN: isNewPlayer,
    playerCreatedAtFN: createdAt,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
      id: json[playerIdFN],
      name: json[playerNameFN],
      email: json[playerEmailFN],
      photoUrl: json[playerGoogleAvatarFN],
      isNewPlayer: json[playerIsNewPlayerFN],
      createdAt: (json[playerCreatedAtFN] as Timestamp).toDate()
  );

}
