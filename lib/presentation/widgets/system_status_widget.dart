import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../shared/theme.dart';

class SystemStatusView extends StatelessWidget {

  const SystemStatusView({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Material(
        color: Colors.transparent,
        child: Obx(() => Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                "assets/images/system_banner.png",
                fit: BoxFit.fill,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(flex: 24, child: Container(height: 1,)),
                    Expanded(flex: 19,
                      child: Row(
                        children: [
                          Expanded(flex: 32,
                            child: AutoSizeText(
                              'player_status'.tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Digital',
                                color: originalColors.textColor2,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(flex: 60,
                            child: AutoSizeText(
                              appController.authState.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: originalColors.textColor3,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          const Expanded(flex: 8,
                              child: Icon(Icons.settings)
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 19,
                      child: Row(
                        children: [
                          Expanded(flex: 32,
                            child: AutoSizeText(
                              "Locale:",
                              style: TextStyle(
                                color: originalColors.textColor2,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          Expanded(flex: 68,
                            child: AutoSizeText(
                              "${Get.locale}",
                              style: TextStyle(
                                color: originalColors.textColor3,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 19,
                      child: Row(
                        children: [
                          Expanded(flex: 32,
                            child: AutoSizeText(
                              'network'.tr,
                              style: TextStyle(
                                color: originalColors.textColor2,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          Expanded(flex: 68,
                            child: AutoSizeText(
                              "${appController.internetStatus}",
                              style: TextStyle(
                                color: originalColors.textColor3,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 19,
                      child: Row(
                        children: [
                          Expanded(flex: 32,
                            child: AutoSizeText(
                              'players_online'.tr,
                              style: TextStyle(
                                color: originalColors.textColor2,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          Expanded(flex: 68,
                            child: StreamBuilder(
                              stream: firestoreService.appGeneralInfo(),
                              builder: (context, AsyncSnapshot snapshot) {
                                return snapshot.connectionState == ConnectionState.waiting
                                ? SpinKitThreeBounce(color: originalColors.textColorLight,)
                                : AutoSizeText(
                                  snapshot.data![appGlobalsOnLineCountFN].toString(),
                                  style: TextStyle(
                                    color: originalColors.textColor3,
                                    fontSize: 18,
                                    fontFamily: 'Digital',
                                  ),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
          ],
        )
        )
    );
  }

}
