import 'package:get/get.dart';

class IntercomBoxLogic extends GetxController {

  final RxList<String> _messages = <String>[].obs;

  List<String> get messages => _messages;

  void postMessage(String message) {
    _messages.add(message);
  }

}
