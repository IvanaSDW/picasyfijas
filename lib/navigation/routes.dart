import 'package:bulls_n_cows_reloaded/di/find_opponent_binding.dart';
import 'package:bulls_n_cows_reloaded/di/solo_game_binding.dart';
import 'package:bulls_n_cows_reloaded/di/versus_game_binding.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/landing_signed_out_view/landing_screen.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_view.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../di/home_binding.dart';
import '../presentation/pages/home_screen/home_view.dart';
import '../presentation/pages/look_for_opponent_screen/find_opponent_view.dart';
import '../presentation/pages/solo_game_screen/solo_game_view.dart';

abstract class Routes {
  static const splash = '/';
  static const landing = '/Landing';
  static const home = '/Home';
  static const findOpponent = '/FindOpponent';
  static const soloGame = '/SoloGame';
  static const versusGame = '/VersusGame';
}

final appPages = [
  GetPage(name: Routes.landing, page: () => LandingUnsignedScreen()),
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
];