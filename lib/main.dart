import 'package:bulls_n_cows_reloaded/firebase_options.dart';
import 'package:bulls_n_cows_reloaded/lang/translator.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/app_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/auth_controller.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/home_screen.dart';
import 'package:bulls_n_cows_reloaded/view/splash_view/splash_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          return GetMaterialApp(
            defaultTransition: Transition.native,
            transitionDuration: const Duration(seconds: 2),
            debugShowCheckedModeBanner: false,
            locale: Get.deviceLocale,
            translations: Translator(),
            home: SplashWidget(snapshot: snapshot,),
            getPages: [
              GetPage(name: '/Home', page: () => HomeView())
            ],
          );
        }
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(AuthController(), permanent: true);
    Get.put(AppController(), permanent: true);
    await Future.delayed(const Duration(seconds: 3));
  }
}
