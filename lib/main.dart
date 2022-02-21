import 'package:bulls_n_cows_reloaded/lang/translator.dart';
import 'package:bulls_n_cows_reloaded/navigation/routes.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/app_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/auth_controller.dart';
import 'package:bulls_n_cows_reloaded/view/splash_view/splash_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

Future<void> main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  } on Exception catch (e) {
    logger.i('Error at booting: $e');
  }
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
            // initialRoute: '/',
            home: SplashWidget(snapshot: snapshot,),
            getPages: appPages,
          );
        }
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform);
    await Firebase.initializeApp();
    Get.put(AuthController(), permanent: true);
    Get.put(AppController(), permanent: true);
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
}
