import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackPanelMenu extends StatelessWidget {
  const BackPanelMenu({
    Key? key, required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool enabled = controller.backPanelOn;
      return Container(
        width: controller.panelWidth,
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
                  leading: enabled
                      ? const Icon(Icons.person, color: Colors.white,)
                      : const Icon(Icons.person, color: Colors.grey,),
                  title: Text('Profile',
                    style: TextStyle(color: enabled ? originalColors.textColor2 : Colors.grey),),
                ),
                ListTile(
                  onTap: () {},
                  leading: enabled
                      ? const Icon(Icons.settings, color: Colors.white,)
                      : const Icon(Icons.settings, color: Colors.grey,),
                  title: Text('Settings',
                    style: TextStyle(color: enabled ? originalColors.textColor2 : Colors.grey),),
                ),
                ListTile(
                  onTap: () {},
                  leading: enabled
                      ? const Icon(Icons.logout, color: Colors.white,)
                      : const Icon(Icons.logout, color: Colors.grey,),
                  title: Text('Logout',
                    style: TextStyle(color: enabled ? originalColors.textColor2 : Colors.grey),),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
