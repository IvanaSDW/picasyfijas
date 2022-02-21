import 'package:bulls_n_cows_reloaded/view/landing_signed_out_view/landing_screen.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../view/home_screen/home_view.dart';
import '../view/solo_match_screen/solo_match_view.dart';

abstract class Routes {
  static const splash = '/';
  static const landing = '/Landing';
  static const home = '/Home';
  static const soloMatch = '/SoloMatch';
}

final appPages = [
  GetPage(name: Routes.landing, page: () => LandingUnsignedScreen()),
  GetPage(name: Routes.home, page: () => HomeView(), curve: Curves.easeIn),
  GetPage(
    name: Routes.soloMatch,
    page: () => SoloMatchPage(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 1700),
  ),
];