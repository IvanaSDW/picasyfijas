import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/anonymous_sign_in_button.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BootingWidget extends StatelessWidget {
  const BootingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'logo',
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
            ),
            child: Get.locale.toString().substring(0, 2) == 'es'
                ? Image.asset('assets/images/logo_spanish_on.png')
                : Image.asset('assets/images/logo_english_on.png'),
          ),
        ),
        const SizedBox(height: 20,),
        TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInCirc,
            builder: (BuildContext context, double opacity, Widget? child) {
              return Opacity(
                  opacity: opacity,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    width: Get.width*0.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Center(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GoogleSignInButtonSquared(),
                        )),
                        const SizedBox(height: 20,),
                        Text('or', style: defaultTextStyle,),
                        const SizedBox(height: 20,),
                        const Center(child: AnonymousSignInButton(),)
                      ],
                    ),
                  )
              );
            }),
      ],
    );
  }
}
