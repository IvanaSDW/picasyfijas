
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {

  RxBool hideBackground = false.obs;
  RxBool showLogo = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 2500), () {
      hideBackground.value = true;
      Get.delete<MatrixEffectController>(tag: 'splash');
    });
    Future.delayed(const Duration(milliseconds: 2000), () => showLogo.value = true);
  }

}
