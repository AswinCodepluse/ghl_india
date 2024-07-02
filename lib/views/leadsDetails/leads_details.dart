import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/common/custom_button.dart';
import 'package:ghl_callrecoding/controllers/attachment_controller.dart';
import 'package:ghl_callrecoding/controllers/call_log_controller.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/controllers/report_controller.dart';
import 'package:ghl_callrecoding/controllers/time_line_controller.dart';
import 'package:ghl_callrecoding/helpers/file_helper.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/lead_datas_create_model.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/utils/custom_rich_text.dart';
import 'package:ghl_callrecoding/utils/custom_text_field.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/conformation_dialog.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/detail_container.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/header_icon_container.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/invest_widget.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/text_card.dart';
import 'package:ghl_callrecoding/views/transaction/screen/transaction_screen.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({
    super.key,
    required this.phoneNumber,
    required this.firstLetter,
    required this.lastLetter,
    required this.leadName,
    required this.leadId,
    required this.email,
    required this.userName,
  });

  final String phoneNumber;
  final String leadName;
  final String firstLetter;
  final String lastLetter;
  final int leadId;
  final String email;

  final String userName;

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  String audioFileData = '';
  File? audioFilesData;
  int? leadID;
  int? userId;
  int? oldStatus;
  String? status;
  String? testNotes;
  String? dates;
  TimeLineController timeLineController = Get.put(TimeLineController());
  AttachmentController attachmentController = Get.put(AttachmentController());
  ReportController reportController = Get.put(ReportController());
  FileController fileController = Get.put(FileController());
  DashboardController dashboardController = Get.find<DashboardController>();

  int? user_Id;
  LeadsController leadsController = Get.put(LeadsController());

  final key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initRecorder();
    timeLineController.leadId.value = widget.leadId;
    timeLineController.fetchTimeLine(widget.leadId);
    attachmentController.fetchAttachment();
    leadsController.fetchIndividualLeads(widget.leadId);
    // leadsController.fetchLastCallRecordingFile(widget.phoneNumber);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    leadsController.isSubmitted = false;
    super.dispose();
  }

  void setButtonEnabled(bool isButtonEnabled) {
    setState(() {
      isButtonEnabled != isButtonEnabled;
    });
  }

  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    if (!await Permission.microphone.request().isGranted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(
      toFile: "audio.aac",
      codec: Codec.aacADTS,
    );
  }

  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    audioFilesData = File(filePath);
    audioFileData = FileHelper.getBase64FormateFile(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Lead Details'),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  color: Color(0XFFFCE9E9), shape: BoxShape.circle),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.firstLetter,
                    style: const TextStyle(
                      color: MyTheme.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.lastLetter,
                    style: const TextStyle(
                      color: MyTheme.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomText(
              text: widget.leadName,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: widget.email,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.email),
                    );
                    ToastComponent.showDialog("Email Copied",
                        gravity: Toast.center, duration: Toast.lengthLong);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.copy,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: widget.phoneNumber,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.phoneNumber),
                    );
                    ToastComponent.showDialog("Phone Number Copied",
                        gravity: Toast.center, duration: Toast.lengthLong);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.copy,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                leadsController.createContact(
                    leadName: widget.leadName, leadNumber: widget.phoneNumber);
              },
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(8),
                child: Text('Add To Contact'),
                decoration: BoxDecoration(
                    color: Color(0XFFFCE9E9),
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            HeaderIconContainer(
              phoneNumber: widget.phoneNumber,
              email: widget.email,
              leadId: widget.leadId,
              screenWidth: screenWidth,
              leadsController: leadsController,
            ),
            Obx(
              () => leadsController.isInvestor.value == 1
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TransactionScreen(
                                        leadId: widget.leadId,
                                      )));
                        },
                        child: Container(
                          width: double.infinity,
                          child: ListTile(
                            leading: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: SizedBox(
                                height: screenWidth / 12,
                                width: screenWidth / 12,
                                child: Image(
                                  image: AssetImage(
                                    "assets/image/transaction_icon.png",
                                  ),
                                ),
                              ),
                            ),
                            title: CustomText(text: "Transaction"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: leadsController.shadow),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
            SizedBox(
              height: 15,
            ),
            Obx(
              () => leadsController.leadDetailsData.value.notes != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Wrap(
                        children: [
                          CustomText(text: "Followup Notes"),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Obx(
                              () => textCard(
                                  text: leadsController
                                          .leadDetailsData.value.notes ??
                                      ""),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
            SizedBox(
              height: 10,
            ),
            detailContainer(leadsController),
            SizedBox(
              height: 10,
            ),
            leadsController.leadDetailsData.value.description != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Wrap(
                      children: [
                        CustomText(text: "Description"),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: textCard(
                              text: leadsController
                                      .leadDetailsData.value.description ??
                                  ""),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            leadsController.leadDetailsData.value.information != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Wrap(
                      children: [
                        CustomText(text: "Information"),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: textCard(
                              text: leadsController
                                      .leadDetailsData.value.information ??
                                  ""),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomText(
                    text: "Add Comments",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Upload File"),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: leadsController.fileCon,
                      hintText: "Select Image File",
                      readOnly: true,
                      onTap: () {
                        leadsController.pickFile("");
                      },
                      prefixIcon: Image(
                          image: AssetImage("assets/image/file_icon.png"))),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(text: "Upload Call Recording File"),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: leadsController.callRecordingFileCon,
                      readOnly: true,
                      hintText: "Select Call Recording File",
                      onChange: (String value) {
                        leadsController.isDisable();
                      },
                      onTap: () {
                        leadsController.pickFile("Call");
                      },
                      prefixIcon: Image(
                          image: AssetImage("assets/image/file_icon.png"))),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(text: "Status"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: leadsController.shadow),
                    child: Obx(
                      () => DropdownButton<Data>(
                        iconSize: 12,
                        underline: SizedBox(),
                        icon: Image(
                          image: AssetImage("assets/image/arrow_down_icon.png"),
                        ),
                        value: leadsController.leadStatusList.isNotEmpty
                            ? leadsController.leadStatusList.firstWhere(
                                (leads) {
                                  return leads.id ==
                                      leadsController.selectedLeadIds.value;
                                },
                                orElse: () {
                                  leadsController.selectedLeadNames.value =
                                      leadsController.leadStatusList[0].name!;
                                  return leadsController.leadStatusList[0];
                                },
                              )
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        items: leadsController.leadStatusList.map((Data item) {
                          return DropdownMenuItem<Data>(
                            value: item,
                            child: Container(
                              width: screenWidth / 1.24,
                              height: 60,
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(item.name!),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: leadsController.onChangeStatus,
                        hint: Text('Select Status'),
                        style: TextStyle(
                          color: MyTheme.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => leadsController.selectedLeadIds.value == 10
                        ? investWidget(context, leadsController)
                        : Container(),
                  ),
                  Obx(
                    () => leadsController.selectedLeadIds.value == 4 ||
                            leadsController.selectedLeadIds.value == 5
                        // leadsController.selectedLeadIds.value == 3 ||
                        //         leadsController.selectedLeadIds.value == 2 ||
                        //         leadsController.selectedLeadIds.value == 11 ||
                        //         leadsController.selectedLeadIds.value == 13 ||
                        //         leadsController.selectedLeadIds.value == 15 ||
                        //         leadsController.selectedLeadIds.value == 18
                        ? Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child:
                                    customRichText(text: "Followup DateTime"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: CustomTextField(
                                  controller: leadsController.dateTimeCon,
                                  readOnly: true,
                                  hintText: "Select DateTime",
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    await leadsController
                                        .dateTimePicker(context);
                                  },
                                  suffixIcon: Icon(
                                    Icons.date_range,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                  customRichText(text: "Followup Notes"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 110,
                    child: CustomTextField(
                        controller: leadsController.followupNotesCon,
                        hintText: "Enter Notes",
                        onChange: (String value) {
                          leadsController.isDisable();
                        },
                        maxLines: 4),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(text: "Record"),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (recorder.isRecording) {
                        await stopRecorder();
                        setState(() {});
                      } else {
                        await startRecord();
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: leadsController.shadow),
                      child: Row(
                        children: [
                          CustomText(
                            text: "Sent Voice",
                          ),
                          Spacer(),
                          recorder.isRecording
                              ? Icon(
                                  Icons.stop,
                                  size: 18,
                                  color: MyTheme.red,
                                )
                              : Image(
                                  image:
                                      AssetImage("assets/image/mic_icon.png"))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              print('audioFilesData file ${audioFilesData}');
              return CustomButton(
                  buttonText: "Submit",
                  disable: leadsController.setDisable.value,
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return conformationDialog(context, leadsController);
                      },
                    );
                    SharedPreference sharedPreference = SharedPreference();
                    String user_Id = await sharedPreference.getUserId();
                    File callRecordingFile =
                        fileController.callRecordingFilesList.isEmpty
                            ? leadsController.callFiles
                            : leadsController.lastCallRecording;
                    LeadDatasCreate response = await leadsController.createLead(
                      leadsController.leadDetailsData.value.id,
                      int.parse(user_Id),
                      leadsController.leadDetailsData.value.statusInt,
                      leadsController.selectedLeadIds.value,
                      leadsController.followupNotesCon.text,
                      leadsController.dateTimeCon.text,
                      "",
                      leadsController.transactionIdCon.text,
                      leadsController.files ?? File(""),
                      callRecordingFile,
                      audioFilesData ?? File(""),
                    );
                    if (response.result == true) {
                      sharedPreference
                          .setRemainderDate(leadsController.remindDate);
                      audioFilesData = File("");
                      callRecordingFile = File("");
                      leadsController.files = File("");
                      leadsController.clearAll();
                      await dashboardController
                          .fetchDashboardData(dashboardController.leadSeasons);
                      leadsController.fetchIndividualLeads(widget.leadId);
                      setState(() {});
                    }
                  });
            }),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
