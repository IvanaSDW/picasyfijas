
import 'package:bulls_n_cows_reloaded/firebase_options.dart';
import 'package:bulls_n_cows_reloaded/lang/translator.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/app_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/auth_controller.dart';
import 'package:bulls_n_cows_reloaded/view/splash_view/splash_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              locale: Get.deviceLocale,
              translations: Translator(),
              home: SplashWidget(snapshot: snapshot,),
          );
        });
  }
}

class Init {
  Init._();
  static final instance = Init._();
  Future initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    Get.put(AuthController(), permanent: true);
    Get.put(AppController(), permanent: true);
    await Future.delayed(const Duration(milliseconds: 3000));
  }
}
