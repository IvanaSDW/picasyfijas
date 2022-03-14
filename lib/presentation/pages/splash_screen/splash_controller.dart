
import 'package:get/get.dart';

class SplashController extends GetxController {

  RxBool hideBackground = false.obs;
  RxBool showLogo = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 2500), () => hideBackground.value = true);
    Future.delayed(const Duration(milliseconds: 4000), () => showLogo.value = true);
  }

}
