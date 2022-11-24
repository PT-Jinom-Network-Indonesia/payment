import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment/common/langs/id_ID.dart';


class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static final fallbackLocale = Locale('id', 'ID');
  @override
  Map<String, Map<String, String>> get keys => {
        'id_ID': id_ID,
      };
}
