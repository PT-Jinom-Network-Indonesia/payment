import 'package:payment/models/customer_details.dart';
import 'package:payment/models/enable_payments.dart';
import 'package:payment/models/grouped_enable_payment.dart';
import 'package:payment/models/item_details.dart';
import 'package:payment/models/merchant.dart';
import 'package:payment/models/transaction_details.dart';

class Transaction {
  TransactionDetails? transactionDetails;
  List<EnabledPayments>? enabledPayments;
  CustomerDetails? customerDetails;
  Merchant? merchant;
  List<ItemDetails>? itemDetails;

  Transaction({
    this.transactionDetails,
    this.enabledPayments,
    this.customerDetails,
    this.merchant,
    this.itemDetails,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionDetails = json['transaction_details'] != null
        ? new TransactionDetails.fromJson(json['transaction_details'])
        : null;
    if (json['enabled_payments'] != null) {
      enabledPayments = <EnabledPayments>[];
      json['enabled_payments'].forEach((v) {
        enabledPayments!.add(new EnabledPayments.fromJson(v));
      });
    }
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
    merchant = json['merchant'] != null
        ? new Merchant.fromJson(json['merchant'])
        : null;
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transactionDetails != null) {
      data['transaction_details'] = this.transactionDetails!.toJson();
    }
    if (this.enabledPayments != null) {
      data['enabled_payments'] =
          this.enabledPayments!.map((v) => v.toJson()).toList();
    }
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails!.toJson();
    }
    if (this.merchant != null) {
      data['merchant'] = this.merchant!.toJson();
    }
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<GroupedEnablePayment> getGroupedEnablePayment() {
    List<GroupedEnablePayment> listGrouped = [];

  if(enabledPayments != null) {
    for (var i = 0; i < enabledPayments!.length; i++) {
      var findGroup = listGrouped.where((GroupedEnablePayment gep) => gep.name == enabledPayments![i].categoryDname);
        if(findGroup.isEmpty) {
          listGrouped.add(GroupedEnablePayment(
            name: enabledPayments![i].categoryDname,
            enablePayment: [enabledPayments![i]]
          ));
        } else {
          findGroup.first.enablePayment!.add(enabledPayments![i]);
        }
    }
  }

    return listGrouped;
  }
}