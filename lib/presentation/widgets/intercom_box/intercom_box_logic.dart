import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class IntercomBoxLogic extends GetxController {

  final RxList<String> _messages = <String>[].obs;

  List<String> get messages => _messages;

  final ScrollController scrollController = ScrollController();

  void postMessage(String message) {
    _messages.add(message);
  }

  void scrollToLastItem() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

}
