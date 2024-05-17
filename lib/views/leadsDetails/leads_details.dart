import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/common/custom_button.dart';
import 'package:ghl_callrecoding/controllers/attachment_controller.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/controllers/time_line_controller.dart';
import 'package:ghl_callrecoding/helpers/file_helper.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/models/lead_datas_create_model.dart';
import 'package:ghl_callrecoding/models/lead_status_model.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:ghl_callrecoding/repositories/time_line_repository.dart';

import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:ghl_callrecoding/views/attachment/attachment_screen.dart';
import 'package:ghl_callrecoding/views/attachment/widget/attachment_container.dart';
import 'package:ghl_callrecoding/views/time_line/time_line_page.dart';
import 'package:ghl_callrecoding/views/time_line/widget/time_line_container.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/file_controller.dart';
import '../../models/lead_details.dart';

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
  FileController fileController = Get.find<FileController>();
  DashboardController dashboardController = Get.find<DashboardController>();
  int? user_Id;

  @override
  void initState() {
    // TODO: implement initState
    initRecorder();
    Dashboard().fetchOIndividualLeads(widget.leadId);
    timeLineController.leadId.value = widget.leadId;
    timeLineController.fetchTimeLine(widget.leadId);
    attachmentController.fetchAttachment();
    // fetchUserId();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    leadsController.isSubmitted = false;
    super.dispose();
  }

  // fetchUserId() async {
  //   user_Id = await SharedPreference().getUserId();
  //   print('user_Id ========== $user_Id');
  // }

  void setButtonEnabled(bool isButtonEnabled) {
    setState(() {
      isButtonEnabled != isButtonEnabled;
    });
  }

  final recorder = FlutterSoundRecorder();
  List<BoxShadow> shadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.0),
      spreadRadius: 0,
      blurRadius: 0,
      offset: Offset(-1, -1),
    ),
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 9,
      blurRadius: 9,
      offset: Offset(5, 5),
    ),
  ];

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
      toFile: "audio.aac", // Recording in WAV format
      codec: Codec.aacADTS, // Using PCM codec for WAV format
    );
  }

  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    // String base64File = await convertFileToBase64(file);
    audioFilesData = File(filePath);
    print("file. path======>${file.path}");
    audioFileData = FileHelper.getBase64FormateFile(file.path);
    print("file. path======>$audioFileData");
    String fileName = file.path.split("/").last;
    setState(() {});
    print('Recorded file path: $filePath');
  }

  LeadsController leadsController = Get.put(LeadsController());

  @override
  Widget build(BuildContext context) {
    // final LeadsController leadsController = Get.find();
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
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.lastLetter,
                    style: const TextStyle(
                      color: Colors.red,
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
            // SizedBox(
            //   height: 10,
            // ),
            // CustomText(
            //   text: "Customer Service Manager",
            //   color: Colors.grey,
            // ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 90,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: shadow
                  // border: Border.all(color: MyTheme.medium_grey, width: 0.5),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            final call =
                                Uri.parse('tel:+91 ${widget.phoneNumber}');
                            if (await canLaunchUrl(call)) {
                              launchUrl(call);
                            } else {
                              throw 'Could not launch $call';
                            }
                          },
                          child: Image(
                            height: 40,
                            image: AssetImage(
                              "assets/image/call_img.png",
                            ),
                          )),
                      CustomText(
                        text: "Call",
                        color: Colors.red,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          leadsController.openSMS(
                              context: context,
                              phoneNumber: widget.phoneNumber);
                        },
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image(
                            image: AssetImage(
                              'assets/image/message_img.png',
                            ),
                            // color: Colors.red,
                          ),
                        ),
                      ),
                      CustomText(
                        text: "Message",
                        color: Colors.red,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          leadsController.openWhatsApp(
                              context, widget.phoneNumber);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: SizedBox(
                          //   height: 40,
                          //   width: 40,
                          //   child: Image(
                          //     image: AssetImage('assets/image/whatsapp.png',),
                          //     color: Colors.red,
                          //   ),
                          // ),
                          child: const SizedBox(
                              height: 40,
                              width: 40,
                              child: Image(
                                  image: AssetImage(
                                "assets/image/whatsapp_img.png",
                              ))),
                        ),
                      ),
                      CustomText(
                        text: "Whatsapp",
                        color: Colors.red,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimeLinePage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: SizedBox(
                          //   height: 40,
                          //   width: 40,
                          //   child: Image(
                          //     image: AssetImage('assets/image/whatsapp.png',),
                          //     color: Colors.red,
                          //   ),
                          // ),
                          child: const SizedBox(
                              height: 40,
                              width: 40,
                              child: Image(
                                  image: AssetImage(
                                "assets/image/activities_img.png",
                              ))),
                        ),
                      ),
                      CustomText(
                        text: "Activities",
                        color: Colors.red,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttachmentScreen()));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: SizedBox(
                          //   height: 40,
                          //   width: 40,
                          //   child: Image(
                          //     image: AssetImage('assets/image/whatsapp.png',),
                          //     color: Colors.red,
                          //   ),
                          // ),
                          child: const SizedBox(
                            height: 40,
                            width: 40,
                            child: Image(
                              image: AssetImage(
                                "assets/image/record_img.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                      CustomText(
                        text: "Record",
                        color: Colors.red,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: FutureBuilder(
                future: Dashboard().fetchOIndividualLeads(widget.leadId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.red,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    LeadDetails leadDetails = snapshot.data!;
                    leadID = leadDetails.id;
                    status = leadDetails.status.toString();
                    dates = leadDetails.lastUpdatedDate;
                    oldStatus = leadDetails.statusInt;
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: shadow),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // titleRow(
                          //     firstTitle: "Lead Name",
                          //     secondTitle: "Assigned to"),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // subTitleRow(
                          //   firstSubTitle: leadDetails.name!,
                          //   secondSubTitle: 'Staff',
                          //   firstIcon: Icons.account_circle,
                          //   secondIcon: Icons.account_circle,
                          // ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          // titleRow(firstTitle: "Email", secondTitle: "Phone"),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // subTitleRow(
                          //     firstSubTitle: leadDetails.email!,
                          //     secondSubTitle: leadDetails.phoneNo!,
                          //     firstIcon: Icons.email,
                          //     secondIcon: Icons.call),
                          SizedBox(
                            height: 15,
                          ),
                          titleRow(firstTitle: "Source", secondTitle: "Medium"),
                          SizedBox(
                            height: 10,
                          ),
                          subTitleRow(
                              firstSubTitle: leadDetails.source!,
                              secondSubTitle: leadDetails.medium!,
                              firstIcon: Icons.location_on_sharp,
                              secondIcon: Icons.account_tree_rounded),
                          SizedBox(
                            height: 15,
                          ),
                          titleRow(
                              firstTitle: "Status", secondTitle: "Occupation"),
                          SizedBox(
                            height: 10,
                          ),
                          subTitleRow(
                              firstSubTitle: leadDetails.status!.toString(),
                              secondSubTitle: leadDetails.occupation ?? "",
                              firstIcon: Icons.circle_rounded,
                              secondIcon: Icons.work),
                          SizedBox(
                            height: 15,
                          ),
                          titleRow(
                              firstTitle: "Designation",
                              secondTitle: "Planning"),
                          SizedBox(
                            height: 10,
                          ),
                          subTitleRow(
                              firstSubTitle: leadDetails.designation ?? "",
                              secondSubTitle: leadDetails.planning!,
                              firstIcon: Icons.cases_outlined,
                              secondIcon: Icons.alarm),
                          SizedBox(
                            height: 15,
                          ),

                          titleRow(
                              firstTitle: "Created On",
                              secondTitle: "Updated On"),
                          SizedBox(
                            height: 10,
                          ),
                          subTitleRow(
                              firstSubTitle: leadDetails.lastUpdatedDate!,
                              secondSubTitle: leadDetails.createdDate!,
                              firstIcon: Icons.calendar_month,
                              secondIcon: Icons.calendar_month),
                          SizedBox(
                            height: 15,
                          ),

                          // SizedBox(
                          //     width: 300,
                          //     child:
                          //         CustomText(text: 'Name: ${leadDetails.name}')),
                          // SizedBox(
                          //     width: 300,
                          //     child: CustomText(
                          //         text: 'Email: ${leadDetails.email}')),
                          // SizedBox(
                          //   width: 300,
                          //   child: CustomText(
                          //       text: 'Phone Number: ${leadDetails.phoneNo}'),
                          // ),
                        ],
                      ),
                    );
                  }
                },
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
                      hintText: "Select Call Recording file",
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
                        boxShadow: shadow
                        // border: Border.all(color: Colors.grey, width: 0.1)
                        ),
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
                                  print(
                                      "00000000+${leadsController.selectedLeadIds.value}");
                                  return leads.id ==
                                      leadsController.selectedLeadIds.value;
                                },
                                orElse: () {
                                  leadsController.selectedLeadIds.value =
                                      leadsController.leadStatusList[0].id!;
                                  print(
                                      "00000000+${leadsController.selectedLeadIds.value}");
                                  return leadsController.leadStatusList[0];
                                },
                              )
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        items: leadsController.leadStatusList.map((Data item) {
                          return DropdownMenuItem<Data>(
                            value: item,
                            child: Container(
                              width: 320,
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
                        },
                        hint: Text('Select Status'),
                        style: TextStyle(
                          color: MyTheme.black,
                        ),
                      ),
                    ),
                  ),
                  // CustomTextField(
                  //     controller: leadsController.statusCon,
                  //     readOnly: true,
                  //     suffixIcon: Image(
                  //         image:
                  //             AssetImage("assets/image/arrow_down_icon.png"))),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(text: "Followup Dates"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: shadow,
                        color: MyTheme.white),
                    child: TextFormField(
                      controller: leadsController.datePickedCon,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.date_range,
                          color: Colors.red,
                        ),
                        hintText: "Select Date",
                        hintStyle:
                            TextStyle(color: MyTheme.grey_153, fontSize: 14),
                        // contentPadding: EdgeInsets.symmetric(
                        //     vertical: 1, horizontal: 10),
                        border: InputBorder.none,
                        // This removes the border
                        enabledBorder: InputBorder.none,
                        // Optional: removes the border when enabled
                        focusedBorder: InputBorder.none,
                        // Optional: removes the border when focused
                        errorBorder: InputBorder.none,
                        // Optional: removes the border when an error is displayed
                        disabledBorder: InputBorder.none,
                        // Optional: removes the border when disabled
                        focusedErrorBorder: InputBorder.none,
                      ),
                      onTap: () async {
                        await leadsController.displayDatePicker(
                            context, leadsController.datePickedCon);
                      },
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
                          boxShadow: shadow
                          // border: Border.all(width: 0.3, color: Colors.grey)
                          ),
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
                  // CustomTextField(
                  //   controller: leadsController.followupNotesCon,
                  //   readOnly: true,
                  //   prefixIcon:
                  //       Image(image: AssetImage("assets/image/mic_icon.png")),
                  //   suffixIcon:
                  //   Image(image: AssetImage("assets/image/file_icon.png")),
                  //
                  // ),
                ],
              ),
            ),
            Obx(() {
              return CustomButton(
                  buttonText: "Submit",
                  disable: leadsController.setDisable.value,
                  onTap: () async {
                    String user_Id = await SharedPreference().getUserId();
                    // if (fileController.filePathsWithPhoneNumber.isEmpty &&
                    //     leadsController.callRecordingFileCon.text.isEmpty) {
                    //   ToastComponent.showDialog(
                    //       "Your Storage Access Denied So Please Upload a Call Recording Files",
                    //       gravity: Toast.center,
                    //       duration: Toast.lengthLong);
                    //   return;
                    // }
                    LeadDatasCreate response = await Dashboard().postLeadDatas(
                      leadID,
                      int.parse(user_Id),
                      oldStatus,
                      leadsController.selectedLeadIds.value,
                      leadsController.followupNotesCon.text,
                      leadsController.datePickedCon.text,
                      leadsController.files ?? File(""),
                      leadsController.lastCallRecording,
                      audioFilesData ?? File(""),
                    );

                    if (response.result == true) {
                      leadsController.clearAll();
                      ToastComponent.showDialog(response.message!,
                          gravity: Toast.center, duration: Toast.lengthLong);
                      // leadsController.setNotification();
                      // String token = '';
                      // FirebaseRepository firebaseRepo = FirebaseRepository();
                      // token = await firebaseRepo.getToken();
                      // firebaseRepo.sendPushNotification(
                      //     token, "Lead Created Successfully");
                      await dashboardController.fetchDashboardData();
                      await Dashboard().fetchOIndividualLeads(widget.leadId);
                      setState(() {});
                      final shouldPop = (await OneContext().showDialog<bool>(
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                            ),
                            content: SizedBox(
                              height: 57,
                              width: 250,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Records are all Submitted"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              ),
                              // TextButton(
                              //     onPressed: () {
                              //       Navigator.pop(context);
                              //     },
                              //     child: Text("No")),
                            ],
                          );
                        },
                      ))!;
                    }
                  });
            }),
            // GestureDetector(
            //   onTap: leadsController.isSubmitted == false
            //       ? () async {
            //     setState(() {
            //       leadsController.isSubmitted = true;
            //     });
            //
            //     String user_Id = await SharedPreference().getUserId();
            //     LeadDatasCreate response =
            //     await Dashboard().postLeadDatas(
            //       leadID,
            //       int.parse(user_Id),
            //       oldStatus,
            //       leadsController.selectedLeadIds.value,
            //       leadsController.followupNotesCon.text,
            //       leadsController.datePicked.toString(),
            //       leadsController.files!,
            //       leadsController.lastCallRecording,
            //       audioFilesData!,
            //     );
            //
            //     if (response.result == true) {
            //       leadsController.clearAll();
            //       ToastComponent.showDialog(
            //         response.message!,
            //         gravity: Toast.center,
            //         duration: Toast.lengthLong,
            //       );
            //
            //       // Assuming fetchOIndividualLeads triggers a network request, await it
            //       await Dashboard().fetchOIndividualLeads(widget.leadId);
            //     }
            //
            //     // setState(() {
            //     //   leadsController.isSubmitted = false;
            //     // });
            //   }
            //       : null,
            //   child: Container(
            //     width: 200,
            //     height: 60,
            //     decoration: BoxDecoration(
            //       color: leadsController.isSubmitted ? Colors.grey : Colors.red,
            //       borderRadius: BorderRadius.circular(15.0),
            //     ),
            //     child: Center(
            //       child: CustomText(
            //         text: "Submit",
            //         color: Colors.white,
            //         fontWeight: FontWeight.w700,
            //         fontSize: 16,
            //       ),
            //     ),
            //   ),
            // ),
            //

            SizedBox(
              height: 20,
            ),
            // Obx(() {
            //   return attachmentController.attachmentList.isNotEmpty
            //       ? Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //           child: Row(
            //             children: [
            //               CustomText(
            //                 text: "Attachment",
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 16,
            //               ),
            //               Spacer(),
            //               GestureDetector(
            //                   onTap: () {
            //                     Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                             builder: (context) =>
            //                                 AttachmentScreen()));
            //                   },
            //                   child: CustomText(text: "View All"))
            //             ],
            //           ),
            //         )
            //       : Container();
            // }),
            // SizedBox(
            //   height: 10,
            // ),
            // Obx(() {
            //   return ListView.builder(
            //       shrinkWrap: true,
            //       physics: NeverScrollableScrollPhysics(),
            //       itemCount: attachmentController.attachmentList.length < 2
            //           ? attachmentController.attachmentList.length
            //           : 2,
            //       itemBuilder: (context, index) {
            //         final data = attachmentController.attachmentList[index];
            //         return attachmentContainer(data);
            //       });
            // }),
            // SizedBox(
            //   height: 10,
            // ),
            // Obx(() {
            //   return timeLineController.activeTimeLineList.isNotEmpty
            //       ? Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //           child: Row(
            //             children: [
            //               CustomText(
            //                 text: "Activity TimeLine",
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 16,
            //               ),
            //               Spacer(),
            //               GestureDetector(
            //                   onTap: () {
            //                     Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                             builder: (context) => TimeLinePage()));
            //                   },
            //                   child: CustomText(text: "View All"))
            //             ],
            //           ),
            //         )
            //       : Container();
            // }),
            // SizedBox(
            //   height: 10,
            // ),
            // Obx(() {
            //   return ListView.builder(
            //       shrinkWrap: true,
            //       physics: NeverScrollableScrollPhysics(),
            //       itemCount: timeLineController.activeTimeLineList.length < 2
            //           ? timeLineController.activeTimeLineList.length
            //           : 2,
            //       itemBuilder: (context, index) {
            //         final data = timeLineController.activeTimeLineList[index];
            //         return timeLineContainer(data);
            //       });
            // })
          ],
        ),
      ),
    );
  }

  Widget titleRow({required String firstTitle, required String secondTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 155,
            child: CustomText(
              text: firstTitle,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          SizedBox(
            width: 120,
            child: CustomText(
              text: secondTitle,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget subTitleRow(
      {required String firstSubTitle,
      required String secondSubTitle,
      required IconData firstIcon,
      required IconData secondIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 155,
            child: Row(
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Icon(
                    firstIcon,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomText(
                    text: firstSubTitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          SizedBox(
            width: 120,
            child: Row(
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Icon(
                    secondIcon,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomText(
                    text: secondSubTitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget CustomTextField(
      {required TextEditingController controller,
      void Function()? onTap,
      Widget? suffixIcon,
      Widget? prefixIcon,
      int? maxLines,
      String? hintText,
      void Function(String)? onChange,
      bool? readOnly}) {
    return Container(
      height: 50,
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        cursorColor: Colors.grey,
        maxLines: maxLines ?? 1,
        // onChanged: dashboardController.searchLead,
        cursorHeight: 20,
        onChanged: onChange,

        onTap: onTap,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
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
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: shadow
          // border: Border.all(color: Colors.grey, width: 0.1),
          ),
    );
  }
}
