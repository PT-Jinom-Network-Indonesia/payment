import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:payment/main.dart';
import 'package:payment/models/virtual_account.dart';
import 'package:payment/pages/home/home.binding.dart';
import 'package:payment/pages/home/home_controller.dart';
import 'package:payment/router/app_pages.dart';

class Payment {
  BuildContext context;
  Payment(this.context);

  List<VirtualAccount> virtualAccounts = [];

  setVirtualAccounts(List<VirtualAccount> va) {
    virtualAccounts = va;
  }

  pay(String token) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => getApp(token, virtualAccounts: virtualAccounts, context: context))
    );
  }
}
