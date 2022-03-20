
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
  double? soloTimeAverage;
  double? soloGuessesAverage;
  String? countryCode;
  bool? isOnline;
  String? pushToken;
  int? rating;


  Player({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.isNewPlayer,
    required this.createdAt,
    required this.soloTimeAverage,
    required this.soloGuessesAverage,
    required this.countryCode,
    required this.isOnline,
    required this.pushToken,
    required this.rating,
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
    playerGuessesAverageFN: soloGuessesAverage,
    playerTimeAverageFN: soloTimeAverage,
    playerCountryCodeFN: countryCode,
    playerIsOnlineFN: isOnline,
    playerPushTokenFN: pushToken,
    playerRatingFN: rating,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json[playerIdFN],
    name: json[playerNameFN],
    email: json[playerEmailFN],
    photoUrl: json[playerGoogleAvatarFN],
    isNewPlayer: json[playerIsNewPlayerFN],
    createdAt: (json[playerCreatedAtFN] as Timestamp).toDate(),
    soloGuessesAverage: double.parse(json[playerGuessesAverageFN].toString()),
    soloTimeAverage: double.parse(json[playerTimeAverageFN].toString()),
    countryCode: json[playerCountryCodeFN],
    isOnline: json[playerIsOnlineFN],
    pushToken: json[playerPushTokenFN],
    rating: json[playerRatingFN],
  );

}
