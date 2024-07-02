import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/transaction_controller.dart';
import 'package:ghl_callrecoding/views/transaction/widget/search_bar.dart';
import 'package:ghl_callrecoding/views/transaction/widget/transaction_alert_dialog.dart';
import 'package:ghl_callrecoding/views/transaction/widget/transaction_card.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class TransactionScreen extends StatefulWidget {
  final int leadId;

  TransactionScreen({Key? key, required this.leadId}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TransactionController transactionController =
      Get.put(TransactionController());

  ScrollController _scrollController = ScrollController();
  final FocusScopeNode _focusNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    transactionController.getTransaction(leadId: widget.leadId.toString());
    _scrollController.addListener(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  transactionController.transactionList.isEmpty
                      ? Container()
                      : Expanded(
                          child: transactionSearchBar(
                              transactionController.searchCon,
                              transactionController,
                              _focusNode),
                        ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      transactionAlertDialog(context, widget.leadId.toString());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.all(9),
                      child: CustomText(
                        text: "+ Add Transaction",
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(
                  () => transactionController.loadingState.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        )
                      : transactionController.transactionList.isEmpty
                          ? Center(
                              child: CustomText(
                              text: "No Transaction Data Found",
                            ))
                          : transactionController.searchCon.text.isNotEmpty &&
                                  transactionController
                                      .searchTransactionList.isEmpty
                              ? Center(
                                  child: CustomText(
                                  text: "No Search Transaction Found",
                                ))
                              : ListView.builder(
                                  reverse: false,
                                  controller: _scrollController,
                                  itemCount: transactionController
                                          .searchCon.text.isNotEmpty
                                      ? transactionController
                                          .searchTransactionList.length
                                      : transactionController
                                          .transactionList.length,
                                  itemBuilder: (context, index) {
                                    final data = transactionController
                                            .searchCon.text.isNotEmpty
                                        ? transactionController
                                            .searchTransactionList[index]
                                        : transactionController
                                            .transactionList[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: transactionCard(data: data),
                                    );
                                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
