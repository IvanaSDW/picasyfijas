import 'dart:ui';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/home_screen.dart';
import 'package:bulls_n_cows_reloaded/view/landing_signed_out_view/landing_signed_out_view.dart';
import 'package:bulls_n_cows_reloaded/view/splash_view/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'matrix_effect.dart';

class SplashWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;

  SplashWidget({Key? key, required this.snapshot}) : super(key: key);
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          MatrixEffect(),
          controller.startButtonVisible.value ? Container() : Container(),
          snapshot.connectionState == ConnectionState.waiting
              ? TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              curve: Curves.easeInCirc,
              builder: (BuildContext context, double opacity,
                  Widget? child) {
                return Opacity(opacity: opacity,
                  child: Center(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaY: 10, sigmaX: 10
                        ),
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Get.locale.toString().substring(0, 2) ==
                                'es'
                                ? Image.asset(
                                'assets/images/logo_spanish.png')
                                : Image.asset(
                                'assets/images/logo_english.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
          )
              : AnimatedSwitcher(
              duration: const Duration(milliseconds: 3000),
              child: authController.authState == AuthState.signedOut
                  ? LandingSignedOutScreen()
                  : TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInCirc,
                  builder: (BuildContext context, double opacity,
                      Widget? child) {
                    return Opacity(
                      opacity: opacity,
                      child: GuestHomePage(),
                    );
                  })
          ),
        ],
      );
    });
  }
}

