import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:payment/common/colors/colors.dart';
import 'package:payment/common/values/widget.dart';
import 'package:payment/main.dart';
import 'package:payment/models/enable_payments.dart';
import 'package:payment/models/grouped_enable_payment.dart';
import 'package:payment/models/item_details.dart';
import 'package:payment/pages/home/home_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:payment/pages/home/home_model.dart';
import 'package:payment/pages/payment_success/payment_success_view.dart';

import 'package:payment/services/services.dart';
import 'package:payment/utils/utils.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';

class HomePage extends GetView<HomeController> {
  static const route = '/home-page';
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: "home-page",
      builder: (controller) => _buildPage(),
    );
  }

  _buildPage() {
    if (controller.loading) return fullscreenLoading();

    if (controller.currentPage == HomePageEnum.TransactionPage)
      return buildViewTransaction();

    if (controller.currentPage == HomePageEnum.SuccessPage)
      return PaymentSuccessPage();

    return SizedBox.shrink();
  }

  _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: ElevatedButton(
        onPressed: () {
          controller.finish();
        },
        child: Text("Close"),
        style: ElevatedButton.styleFrom(
          primary: Colors.grey,
          onPrimary: Colors.white,
        ),
      ),
    );
  }

  Widget buildViewTransaction() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            HexColor.fromHex("${controller.transaction!.merchant!.storeColor}"),
        title: Text("${controller.transaction!.merchant!.merchantName}"),
        leading: Container(
          height: 36,
          width: 36,
          padding: EdgeInsets.all(8),
          child: Image.network(
            "${controller.transaction!.merchant!.merchantLogoUrl}",
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: PADDING_BODY),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: PADDING_BODY,
              ),
              transactionAmount(),
              const SizedBox(
                height: PADDING_BODY,
              ),
              buildFragment(),
              const SizedBox(
                height: PADDING_BODY,
              ),
              _buildCloseButton(Get.context!),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildTextDescription(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget buildFragment() {
    if (controller.fragment == HomeFragment.ChoosedPayment) {
      return buildChoosedPaymentFragment();
    } else {
      return buildPaymentInformationFragment();
    }
  }

  Widget buildChoosedPaymentFragment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        enabledPaymentMethod(
          enabledPayments: controller.transaction?.getGroupedEnablePayment(),
        )
      ],
    );
  }

  Widget buildPaymentInformationFragment() {
    String buildBankTitle() {
      String title = "";
      if (controller.choosedPayment!.category == "bank_transfer" ||
          controller.choosedPayment!.category == "echannel") {
        title = "Bank ${controller.choosedPayment!.name}";
      } else if (controller.choosedPayment!.category == "cstore") {
        title = controller.choosedPayment!.name!;
      }

      return title;
    }

    String _buildDescriptionText() {
      String text = "";

      if (controller.choosedPayment!.category == "bank_transfer" ||
          controller.choosedPayment!.category == "echannel") {
        text =
            "Complete payment from ${controller.choosedPayment!.name} to the virtual account number below";
      } else if (controller.choosedPayment!.category == "cstore") {
        text =
            "Please go to nearest ${controller.choosedPayment!.name} and show the payment code to the cashier.";
      }

      return text;
    }

    String _buildNumberVa() {
      String text = "";
      if (controller.choosedPayment!.category == "bank_transfer") {
        text =
            "${controller.transaction!.transactionDetails!.vaNumbers![0].vaNumber}";
      } else if (controller.choosedPayment!.category == "echannel") {
        text = "${controller.transaction!.transactionDetails!.billKey} ";
      } else if (controller.choosedPayment!.category == "cstore") {
        text = "${controller.transaction!.transactionDetails!.paymentCode}";
      }

      return text;
    }

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextTitle(buildBankTitle()),
          const SizedBox(
            height: PADDING_BODY,
          ),
          buildTextDescription(_buildDescriptionText()),
          const SizedBox(
            height: PADDING_BODY,
          ),
          controller.choosedPayment!.category == 'echannel'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextDescription("Company Code"),
                    const SizedBox(
                      height: 5,
                    ),
                    copyTextField(
                        "${controller.transaction!.transactionDetails!.billerCode}"),
                    const SizedBox(
                      height: PADDING_BODY,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          buildTextDescription(controller.choosedPayment!.category == "cstore"
              ? "Payment Code"
              : "Virtual Account Number"),
          const SizedBox(
            height: 5,
          ),
          copyTextField(_buildNumberVa()),
          const SizedBox(
            height: PADDING_BODY,
          ),
          buildTextTitle("How to pay?"),
          const SizedBox(
            height: PADDING_BODY,
          ),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.choosedPayment!.tutorial!.length,
              itemBuilder: (context, i) {
                return ExpansionTile(
                  title: buildTextDescription(
                      "${controller.choosedPayment!.tutorial![i].header}"),
                  children: [
                    Column(
                      children: _buildExpandableTutorial(i),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildExpandableTutorial(int i) {
    List<Widget> widgets = [];
    int a = 1;
    controller.choosedPayment!.tutorial![i].content!.forEach((String e) {
      widgets.add(ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$a."),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: RichText(
                overflow: TextOverflow.clip,
                text: TextSpan(
                  text: "$e",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
      a++;
    });

    return widgets;
  }

  Widget copyTextField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.grey,
        width: 1,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 36,
            child: IconButton(
              padding: new EdgeInsets.all(0.0),
              icon: Icon(Icons.copy),
              onPressed: () {
                copyText(text);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget fullscreenLoading() {
    return Scaffold(
      body: SizedBox(),
    );
  }

  Widget transactionAmount() {
    return Container(
      width: Get.width,
      child: Card(
        child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextDescription("Total"),
                const SizedBox(
                  height: 5,
                ),
                buildTextTitle(
                  Currency.rupiah(
                    controller.transaction!.transactionDetails!.grossAmount!,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GetBuilder<HomeController>(
                  id: controller.countDownTimer,
                  builder: (controller) {
                    return CountdownTimer(
                      endTime: controller.expiredTimeInMilis(),
                      widgetBuilder: (_, CurrentRemainingTime? time) {
                        addZeroTime(int time) {
                          if (time < 10) {
                            return "0$time";
                          }
                          return time;
                        }

                        if (time == null) {
                          return Text('Expired');
                        }

                        return Row(
                          children: [
                            Text(
                              "Expired in : ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              "${time.days} days ${addZeroTime(time.hours!)}:${addZeroTime(time.min!)}:${addZeroTime(time.sec!)}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: HexColor.fromHex(controller
                                      .transaction!.merchant!.storeColor!)),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            children: [
              SizedBox(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text('Item(s)'),
                    ),
                    DataColumn(
                      label: Text(
                        'QTY',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Price',
                      ),
                    ),
                  ],
                  rows: controller.transaction!.itemDetails!
                      .map(
                        (ItemDetails e) => DataRow(cells: [
                          DataCell(Text("${e.name}")),
                          DataCell(Text(
                            '${e.quantity}',
                            textAlign: TextAlign.center,
                          )),
                          DataCell(Text('${Currency.rupiah(e.price!)}')),
                        ]),
                      )
                      .toList(),
                ),
              )
            ]),
      ),
    );
  }

  Widget enabledPaymentMethod({List<GroupedEnablePayment>? enabledPayments}) {
    if (enabledPayments == null) return SizedBox();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Method",
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(
            height: PADDING_BODY,
          ),
          ...enabledPayments
              .map((GroupedEnablePayment grouped) => Column(
                    children: [
                      groupedPaymentMethod(groupedEnablePayment: grouped),
                      const SizedBox(
                        height: PADDING_BODY,
                      ),
                    ],
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget groupedPaymentMethod({GroupedEnablePayment? groupedEnablePayment}) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${groupedEnablePayment!.name}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          ...groupedEnablePayment.enablePayment!
              .map(
                (EnabledPayments e) => Column(
                  children: [
                    SizedBox(
                      height: 64,
                      child: cardPaymentMethod(
                        enabledPayment: e,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget cardPaymentMethod({EnabledPayments? enabledPayment}) {
    if (enabledPayment == null) return SizedBox.shrink();

    return Card(
      child: InkWell(
        onTap: () {
          // Get.offAndToNamed(TransactionInformationPage.route);
          controller.choosePayment(enabledPayment);
        },
        child: Padding(
          padding: const EdgeInsets.all(PADDING_BODY),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    "${enabledPayment.logoUrl}",
                    width: 50,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${enabledPayment.name}")
                ],
              ),
              enabledPayment.adminFee! > 0 ? Text("+ ${Currency.rupiah(enabledPayment.adminFee!)}", style: TextStyle(color: HexColor.fromHex("${controller.transaction!.merchant!.storeColor}")),) : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
