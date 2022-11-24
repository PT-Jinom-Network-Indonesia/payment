import 'package:flutter/services.dart';
import 'package:payment/services/alert.dart';

copyText(text) {
  Clipboard.setData(
    ClipboardData(
      text: "$text",
    ),
  );

  Alert.toast(text: "Copied to clipboard");
}

readText() async {
  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

  if (data == null) return "";

  return data.text;
}
