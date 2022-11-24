import 'package:get/get.dart';
import 'package:payment/pages/home/home.binding.dart';
import 'package:payment/pages/home/home_view.dart';
import 'package:payment/pages/payment_success/payment_success_view.dart';

class AppPages {
  static const INITIAL = HomePage.route;

  static final routes = [
    GetPage(
      name: HomePage.route,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: PaymentSuccessPage.route,
      page: () => PaymentSuccessPage(),
      binding: HomeBinding(),
    ),
  ];
}
