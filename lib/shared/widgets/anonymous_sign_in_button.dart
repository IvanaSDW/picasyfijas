import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/auth_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnonymousSignInButton extends GetWidget<AuthController> {
  const AnonymousSignInButton({Key? key}) : super(key: key);


  void onTapAction() {
    controller.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTapAction,
        child: SizedBox(width: 150,
            child: Column(
              children: [
                AutoSizeText('Enter as Guest',
                  textAlign: TextAlign.center,
                  style: textButtonStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                AutoSizeText('(basic features)',
                  textAlign: TextAlign.center,
                  style: textButtonStyle,
                  maxFontSize: 12,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
        ),
      ),
    );
  }

}