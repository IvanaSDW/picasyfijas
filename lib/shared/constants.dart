import 'package:bulls_n_cows_reloaded/data/backend_services/firebase_auth_service.dart';
import 'package:bulls_n_cows_reloaded/data/backend_services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

final Logger logger = Logger();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

const String playersTableName = 'players';
const String playerIdFN = 'id';
const String playerNameFN = 'name';
const String playerEmailFN = 'email';
const String playerPhoneFN = 'phone';
const String playerGoogleAvatarFN = 'google_avatar';
const String playerIsNewPlayerFN = 'is_new_user';
const String playerCreatedAtFN = 'created_at';
const String playerTimeAverageFN = 'time_average';
const String playerGuessesAverageFN = 'guesses_average';
const String playerVsModeWinRateFN = 'vs_mode_win_rate';
const String playerCountryCodeFN = 'country_code';
const String playerIsOnlineFN = 'is_online';
const String playerPushTokenFN = 'push_token';
const String playerRatingFN = 'rating';

const String soloGamesTableName = 'solo_matches';
const String soloGamePlayerIdFN = 'player_id';
const String soloGameSecretNumberFN = 'secret_num';
const String soloGameMovesFN = 'moves';
const String soloGameCreatedAtFN = 'created_at';

const String moveGuessFN = 'guess';
const String moveResultFN = 'move_result';
const String moveTimeStamp = 'timestamp';

const String moveDigitsFN = 'digits';
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

const int versusModeTimePresetMillis = 300000;
const int playerPresetRating = 1500;

const monthsEng = <String>[ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', ];
const monthsSpa = <String>[ 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic', ];

