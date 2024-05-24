import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/common/custom_button.dart';
import 'package:ghl_callrecoding/controllers/attachment_controller.dart';
import 'package:ghl_callrecoding/controllers/call_log_controller.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/controllers/file_controller.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/controllers/time_line_controller.dart';
import 'package:ghl_callrecoding/firebase/firebase_repository.dart';
import 'package:ghl_callrecoding/helpers/file_helper.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/lead_datas_create_model.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/conformation_dialog.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/custom_text_feild.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/header_icon_container.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/sub_title_row.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/title_row.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:one_context/one_context.dart';
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

  // CallLogController callLogController = Get.put(CallLogController());
  FileController fileController = Get.find<FileController>();
  DashboardController dashboardController = Get.find<DashboardController>();
  int? user_Id;

  @override
  void initState() {
    initRecorder();
    Dashboard().fetchOIndividualLeads(widget.leadId);
    timeLineController.leadId.value = widget.leadId;
    timeLineController.fetchTimeLine(widget.leadId);
    attachmentController.fetchAttachment();
    leadsController.fetchIndividualLeads(widget.leadId);
    super.initState();
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
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
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
    // String base64File = await convertFileToBase64(file);
    audioFilesData = File(filePath);
    audioFileData = FileHelper.getBase64FormateFile(file.path);
    String fileName = file.path.split("/").last;
    setState(() {});
  }

  LeadsController leadsController = Get.put(LeadsController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    print('screenWidth $screenWidth');
    leadsController.selectedLeadPhoneNumber.value = widget.phoneNumber;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Details'),
        backgroundColor: Colors.transparent,
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
            CustomText(
              text: widget.email,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            CustomText(
              text: widget.phoneNumber,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            SizedBox(
              height: 20,
            ),
            HeaderIconContainer(
              phoneNumber: widget.phoneNumber,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: leadsController.shadow),
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  titleRow(firstTitle: "Source", secondTitle: "Medium"),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => subTitleRow(
                        firstSubTitle:
                            leadsController.leadDetailsData.value.source ?? "",
                        secondSubTitle:
                            leadsController.leadDetailsData.value.medium ?? "",
                        firstIcon: Icons.location_on_sharp,
                        secondIcon: Icons.account_tree_rounded),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  titleRow(firstTitle: "Status", secondTitle: "Occupation"),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => subTitleRow(
                        firstSubTitle:
                            leadsController.leadDetailsData.value.status ?? "",
                        secondSubTitle:
                            leadsController.leadDetailsData.value.occupation ??
                                "",
                        firstIcon: Icons.circle_rounded,
                        secondIcon: Icons.work),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  titleRow(firstTitle: "Designation", secondTitle: "Planning"),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => subTitleRow(
                        firstSubTitle:
                            leadsController.leadDetailsData.value.designation ??
                                "",
                        secondSubTitle:
                            leadsController.leadDetailsData.value.planning ??
                                '',
                        firstIcon: Icons.cases_outlined,
                        secondIcon: Icons.alarm),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  titleRow(firstTitle: "Created On", secondTitle: "Updated On"),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => subTitleRow(
                        firstSubTitle: leadsController
                                .leadDetailsData.value.lastUpdatedDate ??
                            '',
                        secondSubTitle:
                            leadsController.leadDetailsData.value.createdDate ??
                                '',
                        firstIcon: Icons.calendar_month,
                        secondIcon: Icons.calendar_month),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  titleRow(firstTitle: "Interest", secondTitle: "Assigned"),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => subTitleRow(
                        firstSubTitle:
                            leadsController.leadDetailsData.value.interest ??
                                "",
                        secondSubTitle:
                            leadsController.leadDetailsData.value.assigned ??
                                "",
                        firstIcon: Icons.interests,
                        secondIcon: Icons.work),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
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
                        onTap: () {},
                        onChanged: (value) {
                          leadsController.selectedLeadIds.value = value!.id!;
                          leadsController.timeCon.clear();
                          leadsController.selectedLeadNames.value = value.name!;
                        },
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
                  Obx(() {
                    return leadsController.selectedLeadIds.value == 4
                        ? Wrap(
                            children: [
                              CustomText(text: "Select Time"),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: CustomTextField(
                                  controller: leadsController.timeCon,
                                  readOnly: true,
                                  hintText: "Select Time",
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    await leadsController.displayTimePicker(
                                        context, leadsController.timeCon);
                                  },
                                  suffixIcon: Icon(
                                    Icons.access_time,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container();
                  }),
                  CustomText(text: "Followup Dates"),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: leadsController.datePickedCon,
                    readOnly: true,
                    hintText: "Select Date",
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await leadsController.displayDatePicker(
                          context, leadsController.datePickedCon);
                    },
                    suffixIcon: Icon(
                      Icons.date_range,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(text: "Followup Notes"),
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
              return CustomButton(
                  buttonText: "Submit",
                  disable: leadsController.setDisable.value,
                  onTap: () async {
                    SharedPreference sharedPreference = SharedPreference();
                    if (leadsController.selectedLeadIds.value == 4 &&
                        leadsController.timeCon.text.isEmpty) {
                      ToastComponent.showDialog("Select Time",
                          gravity: Toast.center, duration: Toast.lengthLong);
                      return;
                    }
                    String user_Id = await sharedPreference.getUserId();
                    File callRecordingFile =
                        fileController.filePathsWithPhoneNumber.isEmpty
                            ? leadsController.callFiles
                            : leadsController.lastCallRecording;
                    print(
                        'leadsController.callFiles ${leadsController.callFiles}');
                    LeadDatasCreate response = await Dashboard().postLeadDatas(
                      leadsController.leadDetailsData.value.id,
                      int.parse(user_Id),
                      leadsController.leadDetailsData.value.statusInt,
                      leadsController.selectedLeadIds.value,
                      leadsController.followupNotesCon.text,
                      leadsController.datePickedCon.text,
                      leadsController.postTime,
                      leadsController.files ?? File(""),
                      callRecordingFile,
                      audioFilesData ?? File(""),
                    );
                    if (response.result == true) {
                      sharedPreference
                          .setRemainderDate(leadsController.remindDate);
                      if (leadsController.selectedLeadIds.value == 4) {
                        sharedPreference
                            .setRemainderTime(leadsController.postTime);
                      }

                      audioFilesData = File("");
                      callRecordingFile = File("");
                      leadsController.files = File("");
                      leadsController.clearAll();
                      // FirebaseRepository().setNotification();
                      await dashboardController
                          .fetchDashboardData(dashboardController.leadSeasons);
                      await Dashboard().fetchOIndividualLeads(widget.leadId);
                      leadsController.fetchIndividualLeads(widget.leadId);
                      setState(() {});
                      final shouldPop = (await OneContext().showDialog<bool>(
                        builder: (BuildContext context) {
                          return conformationDialog(context);
                        },
                      ));
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
