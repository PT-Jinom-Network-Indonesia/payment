import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payment/models/enable_payments.dart';
import 'package:payment/models/transaction_details.dart';
import 'package:payment/models/transactions.dart';
import 'package:payment/models/virtual_account.dart';
import 'package:payment/pages/home/home_model.dart';
import 'package:payment/services/services.dart';

enum HomeFragment { ChoosedPayment, TransactionInformation }

enum HomePageEnum { SuccessPage, TransactionPage }

class HomeController extends GetxController {
  HomePageEnum currentPage = HomePageEnum.TransactionPage;
  HomeFragment fragment = HomeFragment.ChoosedPayment;
  var homePageId = "home-page";
  var countDownTimer = "countdown-id";
  EnabledPayments? choosedPayment;
  Transaction? transaction = null;
  var expiredTime = 0;
  var platform = MethodChannel('com.jinom.payment/payment');
  var snap_token = "";
  String authToken = "";
  Timer? timer;
  var loading = true;

  var specifiedVirtualAccount = [];

  @override
  void onReady() {
    super.onReady();
    // debugOnReady();
    if(platform.isBlank == true) {
      getAuthToken();
      getSpecifiedVirtualAccount();
    }
  }

  debugOnReady() async {
    await getTransactionDetail();
    await getSpecifiedVirtualAccount();
    watchPeriodic();
  }

  getAuthToken() async {
    try {
      var token = await platform.invokeMethod('authToken');
      authToken = token;

      await getTransaction();
      watchPeriodic();
    } catch (e) {
      finish();
    }
  }

  getSpecifiedVirtualAccount() async {
    try {
      var result = await platform.invokeMethod('getSpecifiedVirtualAccount');

      specifiedVirtualAccount = (json.decoder.convert(result) as List)
          .map((e) => VirtualAccount.fromJson(e))
          .toList();
    } catch (e) {
      // finish();
      print("getTransaction : $e");
      Alert.responseNullDialog(retry: getTransaction());
    }
  }

  getTransaction() async {
    try {
      var result = await platform.invokeMethod("getTransaction");

      Alert.loading();

      Response response = await ApiController()
          .createSnapToken(json.decoder.convert(result), authToken);

      if (response.statusCode == 201) {
        snap_token = response.body['data']['token'];
        print("Snap Token : $snap_token");
        getTransactionDetail();
      } else {
        finish();
      }

      Alert.close();
    } catch (e) {
      print("getTransaction : $e");
      Alert.responseNullDialog(retry: getTransaction());
      finish();
    }
  }

  choosePayment(EnabledPayments ep) async {
    choosedPayment = ep;

    Alert.loading();
    Map<String, dynamic> body = _buildChargeBody(ep);

    Response response = await ApiController().charge(snap_token, body);
    Alert.close();

    if (response.body != null) {
      TransactionDetails td = TransactionDetails.fromJson(response.body);

      if (td.statusCode == 406 &&
          transaction!.transactionDetails!.transactionStatus == "pending") {
        getTransactionDetail();
      } else {
        getTransactionDetail();
      }

      update([homePageId]);
    }
  }

  watchPeriodic() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      getTransactionStatus();
    });
  }

  getTransactionStatus() async {
    Response response = await ApiController().getStatus(snap_token);

    if (response.body != null && response.statusCode == 200) {
      TransactionDetails td = TransactionDetails.fromJson(response.body);

      if (transaction!.transactionDetails!.transactionStatus !=
          td.transactionStatus) {
        transaction!.transactionDetails = td;
        changeLayout();
      }
    }
  }

  _buildChargeBody(EnabledPayments ep) {
    if (ep.category == "bank_transfer") {
      try {
        VirtualAccount va = specifiedVirtualAccount
          .where((virtualAccount) => virtualAccount.bank == ep.type)
          .first;

          return {
          "payment_type": "bank_transfer",
          "bank_transfer": {"bank": ep.type, "va_number": va.vaNumber}
        };
        
      } catch (e) {
        return {
          "payment_type": "bank_transfer",
          "bank_transfer": {"bank": ep.type}
        };
      }
    } else if (ep.category == "echannel") {
      return {
        "payment_type": "echannel",
        "echannel": {
          "bill_info1": "Payment :",
          "bill_info2": " Online Purchase"
        }
      };
    } else if (ep.category == "cstore") {
      return {
        "payment_type": "cstore",
        "cstore": {
          "store": ep.type,
        }
      };
    }
  }

  changeLayout() {
    if (transaction!.transactionDetails!.paymentType != null) {
      if (transaction!.transactionDetails!.paymentType == "bank_transfer") {
        choosedPayment = transaction!.enabledPayments!
            .where(
              (EnabledPayments element) =>
                  element.category == "bank_transfer" &&
                  element.type ==
                      transaction!.transactionDetails!.vaNumbers!.first.bank,
            )
            .first;
      } else if (transaction!.transactionDetails!.paymentType == "echannel") {
        choosedPayment = transaction!.enabledPayments!
            .where((EnabledPayments element) => element.category == "echannel")
            .first;
      } else if (transaction!.transactionDetails!.paymentType == "cstore") {
        choosedPayment = transaction!.enabledPayments!
            .where(
              (EnabledPayments element) =>
                  element.category == "cstore" &&
                  element.type == transaction!.transactionDetails!.store,
            )
            .first;
      }

      if (transaction!.transactionDetails!.transactionStatus == "settlement") {
        currentPage = HomePageEnum.SuccessPage;
        if (timer != null) timer!.cancel();
      } else {
        fragment = HomeFragment.TransactionInformation;
      }
    }

    update([homePageId]);
  }

  getTransactionDetail({bool isLoading = true}) async {
    try {
      if (isLoading) {
        Alert.loading();
      }

      Response response = await ApiController().transactionDetail(snap_token);
      loading = true;

      if (response.body != null) {
        transaction = Transaction.fromJson(response.body);
        await expiredTimeInMilis();
        changeLayout();
      }

      loading = false;
      Alert.close();
    } catch (e) {
      print(e);
      Alert.close();
      Alert.responseNullDialog(retry: () => getTransactionDetail());
    }
    return;
  }

  finish() async {
    SystemNavigator.pop();
    // var result = await platform.invokeMethod("finishActivity");
  }

  expiredTimeInMilis() {
    if (transaction != null) {
      var ext = transaction!.transactionDetails!.expiredAt;
      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse("${ext}");

      expiredTime = tempDate.millisecondsSinceEpoch;

      return expiredTime;
      // var expiredTimeInMilis = ;
      // return new ;
    }
    return 0;
  }

  addZeroTime(int time) {
    if (time < 10) {
      return "0$time";
    }
    return time;
  }
}
