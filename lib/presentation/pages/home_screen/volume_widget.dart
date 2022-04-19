import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/volume_widget_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../shared/constants.dart';

class VolumeWidget extends StatelessWidget {
  VolumeWidget({Key? key,}) : super(key: key);

  final VolumeWidgetController controller = Get.put(VolumeWidgetController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          AutoSizeText(
            'volume'.tr + '        ',
            style: TextStyle(
                color: originalColors.playerTwoBackground
            ),
          ),
          Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 13, bottom: 18),
                  alignment: Alignment.centerLeft,
                  key: controller.trackKey,
                  child: Image.asset(
                    'assets/images/volume_track.png',),
                ),
                Positioned(
                  left: controller.thumbX.value,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) =>
                        controller.onVolumeDragging(details),
                    onHorizontalDragEnd: (details) =>
                        controller.onVolumeDragEnd(details),
                    onHorizontalDragStart: (details) =>
                        controller.onVolumeDragStart(details),
                    child: Container(
                        key: controller.thumbKey,
                        child: appController.isMuted
                            ? Image.asset(
                            'assets/images/volume_tip_on_sound_off.png')
                            : Image.asset(
                            'assets/images/volume_tip_on_sound_on.png')
                    ),
                  ),
                )
              ]
          ),
        ],
      );
    });
  }
}
