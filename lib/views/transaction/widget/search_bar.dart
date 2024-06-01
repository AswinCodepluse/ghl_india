import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/controllers/transaction_controller.dart';

Widget transactionSearchBar(TextEditingController controller,
    TransactionController transactionController, FocusScopeNode focusNode) {
  return Container(
    height: 40,
    child: TextField(
      controller: controller,
      focusNode: focusNode,
      cursorColor: Colors.grey,
      onChanged: transactionController.searchTransactionDate,
      cursorHeight: 20,
      decoration: InputDecoration(
        hintText: "Search...",
        border: InputBorder.none,
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        suffixIcon: controller.text.isEmpty &&
                transactionController.searchTransactionList.isEmpty
            ? SizedBox()
            : GestureDetector(
                onTap: () {
                  transactionController.clearSearchText();
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
              ),
        contentPadding: EdgeInsets.all(8),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
    ),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 0.1)),
  );
}
