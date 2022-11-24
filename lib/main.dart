import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/models/virtual_account.dart';
import 'package:payment/pages/home/home.binding.dart';
import 'package:payment/pages/home/home_controller.dart';
import 'package:payment/pages/home/home_view.dart';
import 'package:payment/router/app_pages.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(getApp(null));
  configLoading();
}

Widget getApp(
  String? token, {
  List<VirtualAccount>? virtualAccounts,
  BuildContext? context,
}) {
  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: AppPages.INITIAL,
    defaultTransition: Transition.fade,
    initialBinding: HomeBinding(),
    getPages: AppPages.routes,
    builder: EasyLoading.init(),
    onReady: () async {
      var homePageController = Get.find<HomeController>();
      if (token != null) {
        homePageController.snap_token = token;
        if (context != null) {
          homePageController.finishMethod = () {
            Navigator.of(context).pop();
          };
        }

        if (virtualAccounts != null && virtualAccounts.length > 0)
          homePageController.specifiedVirtualAccount = virtualAccounts;

        await homePageController.getTransactionDetail();
        homePageController.watchPeriodic();
      } else {
        homePageController.getAuthToken();
        homePageController.getSpecifiedVirtualAccount();
      }
    },
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
