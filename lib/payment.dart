
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:payment/main.dart';
import 'package:payment/pages/home/home.binding.dart';
import 'package:payment/pages/home/home_controller.dart';
import 'package:payment/router/app_pages.dart';



/// A Calculator.
class Payment {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
  pay(String token) {
    launch();
  }
}
