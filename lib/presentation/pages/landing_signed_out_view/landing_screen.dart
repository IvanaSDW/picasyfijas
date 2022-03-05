import 'package:bulls_n_cows_reloaded/presentation/pages/landing_signed_out_view/landing_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../splash_screen/splash_widget.dart';

class LandingUnsignedScreen extends StatelessWidget {
  LandingUnsignedScreen({Key? key}) : super(key: key);
  final LandingController controller = Get.put(LandingController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: showMatrix(),
        builder: (context, AsyncSnapshot snapshot) {
          return SplashWidget(snapshot: snapshot);
        }
    );
  }

  Future showMatrix() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}
