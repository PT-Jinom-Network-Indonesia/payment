import 'package:flutter/material.dart';

double getDeviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getDeviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getDeviceTopHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double getDeviceBottomHeight(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
}
