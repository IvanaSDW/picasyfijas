import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Expanded(flex: 10, child: SizedBox.shrink(),),
                    Expanded(flex: 19,
                      child: Row(
                        children: [
                          Expanded(flex: 28,
                            child: AutoSizeText(
                              'player_status'.tr,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Digital',
                                color: originalColors.textColor2,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(flex: 28,
                            child: AutoSizeText(
                              appController.authState.toString().split('.').last,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: originalColors.textColor3,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          Expanded(flex: 24,
                            child: AutoSizeText(
                              'country'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                color: originalColors.textColor2,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          Expanded(flex: 20,
                            child: AutoSizeText(
                              appController.countryName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                          Expanded(flex: 28,
                            child: AutoSizeText(
                              'network'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                color: originalColors.textColor2,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          Expanded(flex: 28,
                            child: AutoSizeText(
                              "${appController.internetStatus}",
                              maxLines: 1,
                              style: TextStyle(
                                color: originalColors.textColor3,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          Expanded(flex: 24,
                            child: AutoSizeText(
                              'language'.tr,
                              maxLines: 1,
                              style: TextStyle(
                                color: originalColors.textColor2,
                                fontSize: 18,
                                fontFamily: 'Digital',
                              ),
                            ),
                          ),
                          Expanded(flex: 20,
                            child: AutoSizeText(
                            Get.locale!.toLanguageTag(),
                            maxLines: 1,
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
                  ]
              ),
            ),
          ],
        )
        )
    );
  }

}
