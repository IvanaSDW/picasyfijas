import 'package:flutter/cupertino.dart';

import '../splash_screen/splash_widget.dart';

class LandingUnsignedScreen extends StatelessWidget {
  const LandingUnsignedScreen({Key? key}) : super(key: key);

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
