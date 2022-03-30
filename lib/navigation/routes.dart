import 'package:bulls_n_cows_reloaded/di/find_opponent_binding.dart';
import 'package:bulls_n_cows_reloaded/di/solo_game_binding.dart';
import 'package:bulls_n_cows_reloaded/di/versus_game_binding.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/first_run_screen/instructions_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/landing_signed_out_view/landing_screen.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/mode_unlocked_screen/mode_unlocked_view.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/player_profile_screen/player_profile_view.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_view.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../di/home_binding.dart';
import '../presentation/pages/home_screen/home_view.dart';
import '../presentation/pages/look_for_opponent_screen/find_opponent_view.dart';
import '../presentation/pages/solo_game_screen/solo_game_view.dart';
import '../presentation/pages/splash_screen/splash_widget.dart';

abstract class Routes {
  static const splash = '/';
  static const landing = '/Landing';
  static const home = '/Home';
  static const findOpponent = '/FindOpponent';
  static const soloGame = '/SoloGame';
  static const versusGame = '/VersusGame';
  static const profile = '/Profile';
  static const modeUnlocked = '/ModeUnlocked';
  static const instructions = '/Instructions';
}

final appPages = [
  GetPage(
      name: Routes.splash,
      page: () => SplashWidget(),
  ),
  GetPage(name: Routes.landing,
      page: () => const LandingUnsignedScreen()
  ),
  GetPage(
    name: Routes.home,
    page: () => HomeView(),
    binding: HomeBindings(),
  ),
  GetPage(
    name: Routes.soloGame,
    page: () => SoloGamePage(),
    binding: SoloMatchBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 1700),
  ),
  GetPage(
    name: Routes.versusGame,
    page: () => VersusGamePage(),
    binding: VersusGameBindings(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 1700),
  ),
  GetPage(
      name: Routes.findOpponent,
      page: () => FindOpponentView(),
      binding: FindOpponentBindings(),
      transition: Transition.fade,
      curve: Curves.easeInOut,
      transitionDuration: const Duration(milliseconds: 1000),
  ),
  GetPage(
    name: Routes.profile,
    page: () => PlayerProfileView(),
    transition: Transition.fade,
    curve: Curves.easeInOut,
    transitionDuration: const Duration(milliseconds: 1000),
  ),
  GetPage(
    name: Routes.modeUnlocked,
    page: () => ModeUnlockedView(),
    transition: Transition.cupertino,
    curve: Curves.easeInOut,
    transitionDuration: const Duration(milliseconds: 1000),
  ),
  GetPage(
    name: Routes.instructions,
    page: () => InstructionsWidget(onContinueTappedAction: ()=> Get.back()),
    transition: Transition.cupertino,
    curve: Curves.easeInOut,
    transitionDuration: const Duration(milliseconds: 1000),
  ),
];