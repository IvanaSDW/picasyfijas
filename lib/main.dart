import 'package:bulls_n_cows_reloaded/data/backend_services/firestore_service.dart';
import 'package:bulls_n_cows_reloaded/lang/translator.dart';
import 'package:bulls_n_cows_reloaded/navigation/routes.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/app_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/auth_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/backend_services/firebase_auth_service.dart';
import 'data/models/push_notification.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  logger.i('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  } on Exception catch (e) {
    logger.i('Error at booting: $e');
  }

  await MobileAds.instance.initialize();
  RequestConfiguration configuration =
  RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);

  await CountryCodes.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'High importance channel',
    'High importance notifications',
    importance: Importance.high,
    description: 'This channel is used for important notifications.'
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, widget) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
              textScaleFactor: data.textScaleFactor.clamp(1.0, 1.1)
          ),
          child: widget!,
        );
      },
      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      fallbackLocale: Translator.fallbackLocale,
      translations: Translator(),
      initialRoute: Routes.splash,
      getPages: appPages,
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    // await Firebase.initializeApp();
    Get.lazyPut(() => FirestoreService(),);
    Get.lazyPut(() => FirebaseAuthService(),);
    Get.put(AuthController(), permanent: true);
    Get.put(AppController(), permanent: true);
    do {

    } while (
    !Get.isRegistered<FirestoreService>() ||
        !Get.isRegistered<FirebaseAuthService>() ||
        !Get.isRegistered<AuthController>() ||
        !Get.isRegistered<AppController>()
    );
    final prefs = await SharedPreferences.getInstance();
    final isMuted = prefs.getBool('isMuted') ?? false;
    final volume = prefs.getDouble('volumeLevel') ?? 1.0;

    appController.playSplashEffect('audio/matrix_sound.mp3', isMuted ? 0.0 : volume);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('called');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                icon: "notification_icon",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i('called');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        PushNotification notification = PushNotification(
            title: '${message.notification!.title}',
            body: '${message.notification!.body}',
            data: message.data);
        logger.i('notification received: ${notification.toJson()}');
        if(notification.data != null) {
          if (notification.data!.containsKey('showDialog')) {
            logger.i('showDialog came: ${notification.data!['showDialog']}');
            if (notification.data!['showDialog'] == 'true') {
              Get.defaultDialog(
                title: notification.title!,
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
                textCancel: 'OK',
                backgroundColor: Colors.green.withOpacity(0.5),
                buttonColor: originalColors.accentColor2,
                cancelTextColor: originalColors.textColorLight,
              );
            }
          }
        }
      }
    });
    checkForInitialMessage();
    FlutterNativeSplash.remove();
  }

  void checkForInitialMessage() async {
    RemoteMessage? message =
    await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      PushNotification notification = PushNotification(
          title: '${message.notification!.title}',
          body: '${message.notification!.body}',
          data: message.data);
      logger.i('notification received: ${notification.toJson()}');
      if(notification.data != null) {
        if (notification.data!.containsKey('showDialog')) {
          if (notification.data!['showDialog']) {
            Get.defaultDialog(
              title: notification.title!,
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body!)],
                ),
              ),
              textCancel: 'OK',
              backgroundColor: Colors.green.withOpacity(0.5),
              buttonColor: originalColors.accentColor2,
              cancelTextColor: originalColors.textColorLight,
            );
          }
        }
      }
    }
  }
}
