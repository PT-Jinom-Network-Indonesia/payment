import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:payment/common/colors/colors.dart';
import 'package:payment/common/values/values.dart';

class Alert {
  static EasyLoadingMaskType maskType = EasyLoadingMaskType.black;
  static instance() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.light
      ..maskColor = Colors.green
      ..userInteractions = false;
  }

  static bool isDialogOpen = Get.isDialogOpen ?? false;

  static loading() {
    instance();
    EasyLoading.show(status: LOADING_TEXT, maskType: maskType);
  }

  static error(String? value) {
    instance();
    EasyLoading.showError("$value", maskType: maskType);
  }

  static close() {
    EasyLoading.dismiss();
  }

  static success(String value) {
    instance();
    EasyLoading.showSuccess(
      "$value",
      maskType: maskType,
    );
  }

  static snackBar({
    String title = "",
    String message = "",
    SnackPosition? snackPosition,
    Color? backgroundColor,
    Duration? duration,
  }) {
    return Get.snackbar(
      "$title",
      "$message",
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      colorText: AppColors.white,
      margin: EdgeInsets.all(PADDING_BODY),
      duration: duration,
      isDismissible: true,
    );
  }

  static notification({
    String title = "",
    String message = "",
    SnackPosition? snackPosition,
  }) {
    return Get.snackbar(
      "$title",
      "$message",
      snackPosition:
          snackPosition == null ? SnackPosition.BOTTOM : snackPosition,
    );
  }

  static snackBarLoading() {
    return snackBar(title: "Mohon tunggu");
  }

  static forbidden() {
    return snackBar(
      title: "akses ditolak.title".tr,
      message: "akses ditolak.subtitle".tr,
    );
  }

  static unknownError() {
    return snackBar(
      title: "error".tr,
      message: "error 500 message".tr,
    );
  }

  static noInternet() {
    return snackBar(
      title: "koneksi error".tr,
      message: "koneksi error.message".tr,
    );
  }

  static aksesLokasiDibutuhkan() {
    return snackBar(
      message: "permission denied.message".tr,
      title: "permission denied.title".tr,
    );
  }

  static toast({String text = ""}) {
    SnackBar _snakbar = SnackBar(
      content: Text("$text"),
    );
    return ScaffoldMessenger.of(Get.context!).showSnackBar(_snakbar);
  }

  static responseNullDialog({Function? retry}) async {
    // Get.dialog(widget)
    bool isDialogOpen = Get.isDialogOpen ?? false;
    if (isDialogOpen) {
      return null;
    }
    return Get.defaultDialog(
      title: 'Something error while get transaction',
      titleStyle: TextStyle(
        color: Colors.black,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Close",
              style: TextStyle(color: AppColors.red),
            )),
        TextButton(
          onPressed: () {
            if (retry != null) {
              retry();
            }

            Get.back();
          },
          child: Text("Retry"),
        ),
      ],
      middleText: "",
    );
  }

  static responseUnauthorized(Function? cb) async {
    // Get.dialog(widget)
    bool isDialogOpen = Get.isDialogOpen ?? false;
    if (isDialogOpen) {
      return null;
    }
    return Get.defaultDialog(
      title: 'unauthorized'.tr,
      titleStyle: TextStyle(
        color: Colors.black,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back();
            if (cb != null) cb();
          },
          child: Text(
            "kembali".tr,
            style: TextStyle(color: AppColors.red),
          ),
        ),
      ],
      middleText: 'unauthorized.message'.tr,
    );
  }

  static Future<void> startLoading(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor:
              Colors.white, // can change this to your prefered color
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }
}
