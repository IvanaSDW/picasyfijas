import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/first_run_screen/instructions_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/back_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'back_panel.dart';
import 'front_panel.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Obx(() {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 2000),
          child: appController.isFirstRun
              ? InstructionsWidget(onContinueTappedAction: () {appController.isFirstRun = false;})
              : Stack(
            children: [
              BackPanelWidget(),
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: appController.drawerSlideValue),
                  duration: const Duration(milliseconds: 1300),
                  curve: Curves.easeInCirc,
                  builder: (_, double val, __) {
                    return(
                        Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..setEntry(0, 3, appController.panelWidth*val),
                          // ..rotateY((pi/6)*val),
                          child: FrontPanelWidget(controller: controller),
                        )
                    );
                  }),
              Visibility(
                visible: appController.isBusy,
                child: const SpinKitChasingDots(color: Colors.white,),
              ),
            ],
          ),
        );
      }),
    );
  }
}

