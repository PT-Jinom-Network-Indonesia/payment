import 'package:payment/models/virtual_account.dart';

class TransactionDetails {
  String? transactionTime;
  double? grossAmount;
  String? orderId;
  int? statusCode;
  String? transactionStatus;
  String? statusMessage;
  String? expiredAt;
  String? paymentType;
  String? billKey;
  String? billerCode;
  String? store;
  String? paymentCode;
  List<VirtualAccount>? vaNumbers;

  TransactionDetails({
    this.transactionTime,
    this.grossAmount,
    this.orderId,
    this.statusCode,
    this.transactionStatus,
    this.statusMessage,
    this.expiredAt,
    this.paymentType,
    this.vaNumbers,
    this.billKey,
    this.billerCode,
    this.store,
    this.paymentCode,
  });

  TransactionDetails.fromJson(Map<String, dynamic> json) {
    transactionTime = json['transaction_time'];
    grossAmount = json['gross_amount'] != null
        ? double.parse("${json['gross_amount']}")
        : 0;
    orderId = json['order_id'];
    statusCode =
        json['status_code'] == null ? 500 : int.parse("${json['status_code']}");
    transactionStatus = json['transaction_status'];
    statusMessage = json['status_message'];
    expiredAt = json['expired_at'];
    paymentType = json['payment_type'];
    billKey = json['bill_key'];
    billerCode = json['biller_code'];
    store = json['store'];
    paymentCode = json['payment_code'];
    if (json['va_numbers'] != null) {
      vaNumbers = <VirtualAccount>[];
      json['va_numbers'].forEach((v) {
        vaNumbers!.add(new VirtualAccount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_time'] = this.transactionTime;
    data['gross_amount'] = this.grossAmount;
    data['order_id'] = this.orderId;
    data['status_code'] = this.statusCode;
    data['transaction_status'] = this.transactionStatus;
    data['status_message'] = this.statusMessage;
    data['expired_at'] = this.expiredAt;
    data['payment_type'] = this.paymentType;
    data['bill_key'] = this.billKey;
    data['biller_code'] = this.billerCode;
    data['store'] = this.store;
    data['payment_code'] = this.paymentCode;
    if (this.vaNumbers != null) {
      data['va_numbers'] = this.vaNumbers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}