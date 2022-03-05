import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/theme.dart';

class BackPanelMenu extends StatelessWidget {
  const BackPanelMenu({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool enabled = appController.backPanelOn;
      Color iconColor = enabled ? Colors.white : Colors.black45;
      Color menuTextColor = enabled ? originalColors.textColor2! : Colors.black45;
      return Container(
        width: appController.panelWidth,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  enabled: enabled,
                  onTap: () {},
                  leading: Icon(Icons.person, color: iconColor,),
                  title: Text('Profile',
                    style: TextStyle(color: menuTextColor,),
                  ),
                ),
                ListTile(
                  enabled: enabled,
                  onTap: () {},
                  leading: Icon(Icons.settings, color: iconColor,),
                  title: Text('Settings',
                    style: TextStyle(color: menuTextColor),),
                ),
                ListTile(
                  enabled: enabled,
                  onTap: () => authController.signOut(),
                  leading: Icon(Icons.logout, color: iconColor,),
                  title: Text('Logout',
                    style: TextStyle(color: menuTextColor),),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
