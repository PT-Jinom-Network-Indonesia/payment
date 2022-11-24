import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payment/common/values/values.dart';
import 'package:payment/models/item_details.dart';
import 'package:payment/pages/home/home_controller.dart';
import 'package:payment/pages/home/home_model.dart';
import 'package:payment/utils/utils.dart';

class PaymentSuccessPage extends GetView<HomeController> {
  static const route = '/payment-success-page';
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(PADDING_BODY),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSuccessIcon(),
                _buildHeightPadding(),
                _buildSuccessPaymentText(),
                _buildHeightPadding(),
                _buildDetailTransaction(),
                _buildHeightPadding(),
                _buildCloseButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  _buildHeightPadding({double? height}) {
    return SizedBox(
      height: (height != null) ? height : PADDING_BODY,
    );
  }

  _buildSuccessIcon() {
    return const SizedBox(
      child: Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 80,
      ),
    );
  }

  _buildSuccessPaymentText() {
    return Column(
      children: [
        const Text(
          "Payment Success",
          style: TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildHeightPadding(height: 10),
        Text("${Currency.rupiah(controller.transaction!.transactionDetails!.grossAmount!)}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  _buildDetailTransaction() {
    return SizedBox(
      width: Get.width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(PADDING_BODY),
              child: _buildTextTitle("Transaction detail"),
            ),
            SizedBox(
              child: DataTable(
                columns: const [
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
                rows: [
                  ...controller.transaction!.itemDetails!
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
                  DataRow(cells: [
                    const DataCell(Text("Total")),
                    const DataCell(Text("")),
                    DataCell(Text(
                        "${Currency.rupiah(controller.transaction!.transactionDetails!.grossAmount!)}")),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCloseButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        controller.finish();
      },
      child: const Text("Close"),
      style: ElevatedButton.styleFrom(
        primary: Colors.grey,
        onPrimary: Colors.white,
      ),
    );
  }
}
