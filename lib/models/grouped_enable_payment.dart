import 'package:payment/models/enable_payments.dart';

class GroupedEnablePayment {
  String? name;
  List<EnabledPayments>? enablePayment;

  GroupedEnablePayment({this.name, this.enablePayment});
}