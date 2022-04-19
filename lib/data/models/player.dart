
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String? id;
  String? name;
  String? nickName;
  String? email;
  String? phone;
  String? photoUrl;
  List<String>? addedAvatarsUrls;
  bool? isNewPlayer = true;
  DateTime? createdAt;
  double? soloTimeAverage;
  double? soloGuessesAverage;
  String? countryCode;
  bool? isOnline;
  String? pushToken;
  int? rating;
  bool? isVsUnlocked = false;
  bool? isRated = false;

  Player({
    required this.id,
    required this.name,
    this.nickName,
    required this.email,
    required this.photoUrl,
    this.addedAvatarsUrls,
    required this.isNewPlayer,
    required this.createdAt,
    required this.soloTimeAverage,
    required this.soloGuessesAverage,
    required this.countryCode,
    required this.isOnline,
    required this.pushToken,
    required this.rating,
    required this.isVsUnlocked,
    required this.isRated,
  });

  Player.empty();

  Map<String, dynamic> toJson() => {
    playerIdFN: id,
    playerNameFN: name,
    playerNickNameFN: nickName,
    playerEmailFN: email,
    playerPhoneFN: phone,
    playerGoogleAvatarFN: photoUrl,
    playerAddedAvatarsUrlsFN: addedAvatarsUrls,
    playerIsNewPlayerFN: isNewPlayer,
    playerCreatedAtFN: createdAt,
    playerGuessesAverageFN: soloGuessesAverage,
    playerTimeAverageFN: soloTimeAverage,
    playerCountryCodeFN: countryCode,
    playerIsOnlineFN: isOnline,
    playerPushTokenFN: pushToken,
    playerRatingFN: rating,
    playerIsVsUnlockedFN: isVsUnlocked,
    playerIsRatedFN: isRated,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json[playerIdFN],
    name: json[playerNameFN],
    nickName: json[playerNickNameFN],
    email: json[playerEmailFN],
    photoUrl: json[playerGoogleAvatarFN],
    addedAvatarsUrls: json[playerAddedAvatarsUrlsFN] == null ? null : (json[playerAddedAvatarsUrlsFN] as List).map((e) => e.toString()).toList(),
    isNewPlayer: json[playerIsNewPlayerFN],
    createdAt: (json[playerCreatedAtFN] as Timestamp).toDate(),
    soloGuessesAverage: json[playerGuessesAverageFN] == null ? null : double.parse(json[playerGuessesAverageFN].toString()),
    soloTimeAverage: json[playerTimeAverageFN] == null ? null : double.parse(json[playerTimeAverageFN].toString()),
    countryCode: json[playerCountryCodeFN],
    isOnline: json[playerIsOnlineFN],
    pushToken: json[playerPushTokenFN],
    rating: json[playerRatingFN],
    isVsUnlocked: json[playerIsVsUnlockedFN],
    isRated: json[playerIsRatedFN],
  );

}
