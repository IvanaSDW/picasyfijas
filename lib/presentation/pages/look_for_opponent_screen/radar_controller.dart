import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadarController extends GetxController with GetSingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation = Tween<double>(begin: 0, end: pi * 2).animate(_animationController);
    _animationController.repeat();
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}