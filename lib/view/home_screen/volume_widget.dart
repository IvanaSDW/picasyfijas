import 'package:bulls_n_cows_reloaded/view/home_screen/volume_widget_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../shared/constants.dart';

class VolumeWidget extends StatelessWidget {
  VolumeWidget({Key? key,}) : super(key: key);

  final VolumeWidgetController controller = Get.put(VolumeWidgetController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
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
                  child: appController.backPanelOn
                      ? appController.isMuted
                      ? Image.asset(
                      'assets/images/volume_tip_on_sound_off.png')
                      : Image.asset(
                      'assets/images/volume_tip_on_sound_on.png')
                      : Image.asset(
                      'assets/images/volume_tip_off.png'),
                ),
              ),
            )
          ]
      );
    });
  }
}
