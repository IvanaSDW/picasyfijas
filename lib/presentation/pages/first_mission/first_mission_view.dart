import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'first_mission_logic.dart';

class FirstMissionPage extends StatelessWidget {
  const FirstMissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<FirstMissionLogic>();
    final state = Get.find<FirstMissionLogic>().state;

    return Container();
  }
}
