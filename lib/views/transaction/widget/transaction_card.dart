import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/models/get_transaction_model.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Widget transactionCard({required TransactionData data}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(
            text: data.txnId ?? '',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.red,
          ),
          transactionRow(
            title: 'Amount',
            value: data.amount ?? '',
          ),
          transactionRow(
            title: 'Date',
            value: data.date ?? '',
          ),
          transactionRow(
            title: 'CreatedAt',
            value: data.createdAt ?? '',
          ),
          transactionRow(
            title: 'UpdatedAt',
            value: data.updatedAt ?? '',
          )
        ],
      ),
    ),
  );
}

Widget transactionRow({required String title, required String value}) {
  return Row(
    children: [
      Container(
          width: 100,
          child: CustomText(
            text: title,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomText(
          text: ':',
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      Expanded(child: CustomText(text: value))
    ],
  );
}
