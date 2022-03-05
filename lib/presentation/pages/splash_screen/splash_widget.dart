import 'dart:ui';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/landing_signed_out_view/booting_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../presentation/widgets/matrix_effect/matrix_effect.dart';


class SplashWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const SplashWidget({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i(
        'AsyncSnapshot state: ${snapshot.connectionState}, Current route: ${Get
            .currentRoute}');
    return Get.currentRoute == '/HomeView' &&
        snapshot.connectionState == ConnectionState.done
        ? Container(color: Colors.transparent,)
        : Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            MatrixEffect(),
            snapshot.connectionState == ConnectionState.waiting
                ? TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
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
                                  'assets/images/logo_spanish_on.png')
                                  : Image.asset(
                                  'assets/images/logo_english_on.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
            )
                : Obx(() => appController.authState == AuthState.booting ||
                appController.authState == AuthState.signedOut
                ? const BootingWidget()
                : Container(color: Colors.transparent,),
            ),
          ],
        )
    );
  }
}

