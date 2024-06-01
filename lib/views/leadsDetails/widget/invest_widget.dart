import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/utils/custom_rich_text.dart';
import 'package:ghl_callrecoding/utils/custom_text_field.dart';

Widget investWidget(BuildContext context) {
  LeadsController leadsController = Get.find<LeadsController>();
  return Wrap(
    children: [
      customRichText(text: "Amount"),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: CustomTextField(
          controller: leadsController.amountCon,
          hintText: "Enter Amount",
          keyboardType: TextInputType.number,
          onChange: (String value) {
            leadsController.isDisable();
          },
        ),
      ),
      customRichText(text: "Invest Date"),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomTextField(
          controller: leadsController.investDateCon,
          readOnly: true,
          hintText: "Select Invest Date",
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            await leadsController.displayDatePicker(
                context, leadsController.investDateCon);
          },
          suffixIcon: Icon(
            Icons.date_range,
            color: Colors.red,
          ),
        ),
      ),
      customRichText(text: "Invest Type"),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomTextField(
          controller: leadsController.investTypeCon,
          hintText: "Example : PT",
          onChange: (String value) {
            leadsController.isDisable();
          },
        ),
      ),
      customRichText(text: "Transaction Id"),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: CustomTextField(
          controller: leadsController.transactionIdCon,
          hintText: "Enter Transaction Id",
          onChange: (String value) {
            leadsController.isDisable();
          },
        ),
      ),
    ],
  );
}
