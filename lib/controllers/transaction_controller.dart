import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/models/get_transaction_model.dart';
import 'package:ghl_callrecoding/models/post_transaction_models.dart';
import 'package:ghl_callrecoding/repositories/transaction_repository.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class TransactionController extends GetxController {
  TransactionRepository transactionRepository = TransactionRepository();
  RxList<TransactionData> transactionList = <TransactionData>[].obs;
  RxList<TransactionData> searchTransactionList = <TransactionData>[].obs;
  RxBool loadingState = false.obs;
  TextEditingController amountCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  TextEditingController transactionIdCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();
  RxBool postLoadingState = false.obs;
  RxBool disable = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> getTransaction({required String leadId}) async {
    loadingState.value = true;
    transactionList.clear();
    GetTransactionModel response =
        await transactionRepository.getTransaction(leadId);
    transactionList.addAll(response.data!);
    loadingState.value = false;
  }

  Future<void> displayDatePicker(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(4000));
    if (date != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(date);
      dateCon.text = formattedDate;
      isDisable();
    }
    update();
  }

  void onTapCancel(BuildContext context) {
    clearAll();
    Navigator.pop(context);
  }

  void onTapSave(BuildContext context, String leadId) async {
    postLoadingState.value = true;
    TransactionPostData transactionPostData =
        await transactionRepository.createTransaction(
            leadId: leadId,
            date: dateCon.text,
            transactionId: transactionIdCon.text,
            amount: amountCon.text);
    postLoadingState.value = false;
    ToastComponent.showDialog(transactionPostData.message!,
        gravity: Toast.center, duration: Toast.lengthLong);
    if (transactionPostData.result == true) {
      clearAll();
      Navigator.pop(context);
      getTransaction(leadId: leadId);
    }
  }

  searchTransactionDate(String str) {
    searchTransactionList.value = transactionList
        .where((data) => data.date!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
    update();
  }

  void isDisable() {
    if ((dateCon.text.isEmpty || dateCon.text == '') ||
        (amountCon.text.isEmpty || amountCon.text == '') ||
        (transactionIdCon.text.isEmpty || transactionIdCon.text == '')) {
      disable.value = false;
    } else {
      disable.value = true;
    }
    update();
  }

  clearSearchText() {
    searchTransactionList.clear();
    searchCon.clear();
    update();
  }

  clearAll() {
    dateCon.clear();
    transactionIdCon.clear();
    amountCon.clear();
  }
}
