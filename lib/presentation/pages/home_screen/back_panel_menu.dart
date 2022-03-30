import 'package:bulls_n_cows_reloaded/navigation/routes.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/back_panel_controller.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_stats_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../shared/theme.dart';

class BackPanelMenu extends StatelessWidget {
  const BackPanelMenu({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool enabled = appController.backPanelOn;
      Color iconColor = enabled ? Colors.white : originalColors.reverseTextColor!;
      Color menuTextColor = enabled ? originalColors.textColor2! : originalColors.reverseTextColor!;
      return Container(
        width: appController.panelWidth,
        padding: const EdgeInsets.all(0.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 6),
                  horizontalTitleGap: 0.0,
                  enabled: enabled,
                  onTap: () => Get.find<BackPanelController>().onProfileMenuPressed(),
                  leading: Icon(Icons.person, color: iconColor,),
                  title: Text('profile'.tr,
                    style: TextStyle(color: menuTextColor, fontFamily: 'Mainframe', fontSize: 13),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 6),
                  horizontalTitleGap: 0.0,
                  enabled: enabled && (appController.needUpdateVsStats.value || appController.needUpdateSoloStats.value),
                  onTap: () async {await Get.find<PlayerStatsController>().refreshStats(auth.currentUser!.uid);},
                  leading: Get.find<PlayerStatsController>().isSyncing
                      ? const SizedBox(height: 18, width: 18, child: SpinKitDualRing(color: Colors.white, size: 18,))
                      : Icon(Icons.sync_outlined, color: appController.needUpdateVsStats.value || appController.needUpdateSoloStats.value
                      ? iconColor : originalColors.reverseTextColor,),
                  title: Text('refresh_stats'.tr,
                    style: TextStyle(fontFamily: 'Mainframe', fontSize: 13,
                        color: appController.needUpdateVsStats.value || appController.needUpdateSoloStats.value
                        ? menuTextColor : originalColors.reverseTextColor),),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 6),
                  horizontalTitleGap: 0.0,
                  enabled: enabled,
                  onTap: () => Get.toNamed(Routes.instructions),
                  leading: Icon(Icons.help_outline, color: iconColor,),
                  title: Text('instructions'.tr,
                    style: TextStyle(color: menuTextColor, fontFamily: 'Mainframe', fontSize: 13),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 6),
                  horizontalTitleGap: 0.0,
                  enabled: enabled && appController.authState != AuthState.anonymous,
                  onTap: () => authController.signOut(),
                  leading: Icon(Icons.logout, color: appController.authState == AuthState.anonymous ? Colors.black45 : iconColor,),
                  title: Text(
                    'logout'.tr,
                    style: TextStyle(fontFamily: 'Mainframe', fontSize: 13,
                      color: appController.authState == AuthState.anonymous ? Colors.black45 : menuTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
