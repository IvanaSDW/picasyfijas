import 'package:bulls_n_cows_reloaded/data/backend_services/firebase_auth_service.dart';
import 'package:bulls_n_cows_reloaded/data/backend_services/firestore_service.dart';
import 'package:bulls_n_cows_reloaded/shared/rating_calculator.dart';
import 'package:bulls_n_cows_reloaded/data/backend_services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'controllers/app_controller.dart';
import 'controllers/auth_controller.dart';

enum AuthState { booting, anonymous, google, signedOut }
enum SoloGameStatus { created, started, finished }
enum PlayerSide { self, opponent }
enum VersusPlayer { unknown, player1, player2, none }
enum WinnerPlayer { unknown, player1, player2, draw }
enum WinByMode { unknown, draw, moves, time, opponentLeft, opponentTimeUp }
enum VersusGameStatus { unknown, created, started, semiFinished, finished, cancelled }

final AuthController authController = AuthController.instance;
final AppController appController = AppController.instance;
final FirestoreService firestoreService = FirestoreService.instance;
final FirebaseAuthService authService = FirebaseAuthService.instance;
final FirebaseStorage fbStorage = FirebaseStorage.instance;
final StorageService storageService = StorageService();

final RatingCalculator ratingCalculator = RatingCalculator();
final Logger logger = Logger();
final FirebaseAuth auth = FirebaseAuth.instance;

const String playersTableName = 'players';
const String playerIdFN = 'id';
const String playerNameFN = 'name';
const String playerNickNameFN = 'nick_name';
const String playerEmailFN = 'email';
const String playerPhoneFN = 'phone';
const String playerGoogleAvatarFN = 'google_avatar';
const String playerAddedAvatarsUrlsFN = 'added_avatars';
const String playerIsNewPlayerFN = 'is_new_user';
const String playerCreatedAtFN = 'created_at';
const String playerTimeAverageFN = 'time_average';
const String playerGuessesAverageFN = 'guesses_average';
const String playerVsModeWinRateFN = 'vs_mode_win_rate';
const String playerCountryCodeFN = 'country_code';
const String playerIsOnlineFN = 'is_online';
const String playerPushTokenFN = 'push_token';
const String playerRatingFN = 'rating';
const String playerIsVsUnlockedFN = 'is_vs_unlocked';
const String playerIsRatedFN = 'is_rated';

const String soloGamesTableName = 'solo_matches';
const String soloGamePlayerIdFN = 'player_id';
const String soloGameSecretNumberFN = 'secret_num';
const String soloGameMovesFN = 'moves';
const String soloGameCreatedAtFN = 'created_at';

const String moveGuessFN = 'guess';
const String moveResultFN = 'move_result';
const String moveTimeStamp = 'timestamp';

const String resultBullsFN = 'bulls';
const String resultCowsFN = 'cows';

const String versusGamesTableName = 'versus_games';
const String versusGamePlayerOneIdFN = 'player_one_id';
const String versusGamePlayerTwoIdFN = 'player_two_id';
const String versusGamePlayerOneMatchFN = 'player_one_match';
const String versusGamePlayerTwoMatchFN = 'player_two_match';
const String vsGameP1RatingFN = 'p1_rating';
const String vsGameP2RatingFN = 'p2_rating';
const String versusGameWinnerIdFN = 'winner_id';
const String versusGameWhoIsToMoveFN = 'player_to_move';
const String versusGameCreatedAtFN = 'created_at';
const String versusGameStatusFN = 'state';
const String versusGameWinnerPlayerFN = 'winner_player';
const String versusGameWinByModeFN = 'winner_by_mode';
const String versusGamePlayerOneFoundFN = 'player_one_found';
const String versusGamePlayerTwoFoundFN = 'player_two_found';

const String versusChallengesTableName = 'versus_challenges_queue';
const String versusChallengeChallengerIdFN = 'player_one_id';
const String vsChallengeP1RatingFN = 'p1_rating';
const String vsChallengeP2RatingFN = 'p2_rating';
const String versusChallengeOpponentIdFN = 'player_two_id';
const String versusChallengeAssignedGameIdFN = 'assigned_match_id';
const String versusChallengeCreatedAtFN = 'created_at';

const String appGlobalsTableName = 'app_globals';
const String appGlobalsGeneralInfoDN = 'general_info';
const String appGlobalsOnLineCountFN = 'online_count';
const String appGlobalsVersusGamesCountFN = 'vs_games_count';

const String appGlobalsSettingsDN = 'settings';
const String appSettingsPlayStoreDynamicLinkFN = 'play_store_dynamic_link';

const int versusModeTimePresetMillis = 300000;
const int playerPresetRating = 1500;
const int minSoloGamesToUnlockVsMode = 3;
const int maxTimeAverageToUnlockVsMode = 300000;
const int minVsGamesToStartRating = 5;
const int kFactorForInitialRating = 40;
const int kFactorBelow2400 = 20;
const int kFactorAbove2400 = 10;
const int kFactorForBlitz = 20;
const int ratingRangeFactor = 400;

const monthsEng = <String>[ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', ];
const monthsSpa = <String>[ 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic', ];

const String botPlayerDocId = 'botplayer';
const String botPlayerAvatarUrl = 'https://source.unsplash.com/random/200x200/?face';
const String randomUserUrl = 'https://randomuser.me/api/?results=1';

const List<String> testDeviceIds = [
  'B3EEABB8EE11C2BE770B684D95219ECB',
  "AD402BC6C6000368CBBB4378010553EB",
];

const String playerAvatarStorageTN = 'avatar_images';

const Map<String, int> ratingDpTable = {
  '0.49' : -7, '0.48' : -14, '0.47' : -21, '0.46' : -29,
  '0.45' : -36, '0.44' : -43, '0.43' : -50, '0.42' : -57,
  '0.41' : -65, '0.40' : -72, '0.39' : -80, '0.38' : -87,
  '0.37' : -95, '0.36' : -102, '0.35' : -110, '0.34' : -117,
  '0.33' : -125, '0.32' : -133, '0.31' : -141, '0.30' : -149,
  '0.29' : -158, '0.28' : -166, '0.27' : -175, '0.26' : -184,
  '0.25' : -193, '0.24' : -202, '0.23' : -211, '0.22' : -220,
  '0.21' : -230, '0.20' : -240, '0.19' : -251, '0.18' : -262,
  '0.17' : -273, '0.16' : -284, '0.15' : -296, '0.14' : -309,
  '0.13' : -322, '0.12' : -336, '0.11' : -351, '0.10' : -366,
  '0.09' : -383, '0.08' : -401, '0.07' : -422, '0.06' : -444,
  '0.05' : -470, '0.04' : -501, '0.03' : -538, '0.02' : -589,
  '0.01' : -677, '0.00' : -800,
};