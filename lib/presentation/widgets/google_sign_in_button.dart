import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../shared/constants.dart';

class GoogleSignInButtonSquared extends StatelessWidget {
  const GoogleSignInButtonSquared({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: appController.isBusy
          ? const SpinKitChasingDots(color: Colors.white,)
          : InkWell(
              onTap: () async => appController.authState == AuthState.signedOut
                  ? await authController.signInWithGoogle()
                  : await authController.upgradeAnonymousToGoogle(),
              child: appController.locale.toString().substring(0, 2) == 'es'
                  ? Image.asset('assets/images/google_square_button_spanish.png')
                  : Image.asset('assets/images/google_square_button.png')
            ),
    );
  }
}
