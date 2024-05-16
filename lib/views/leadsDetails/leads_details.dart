import 'dart:io';

import 'package:flutter/material.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/lead_details.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen(
      {super.key,
      required this.phoneNumber,
      required this.firstLetter,
      required this.lastLetter,
      required this.leadName,
      required this.leadId});

  final String phoneNumber;
  final String leadName;
  final String firstLetter;
  final String lastLetter;
  final int leadId;

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  String audioFileData = '';
  int? leadID;
  int? userId;
  int? oldStatus;
  String? status;
  String? testNotes;
  String? dates;
  TimeLineController timeLineController = Get.put(TimeLineController());
  AttachmentController attachmentController = Get.put(AttachmentController());
  int? user_Id;

  @override
  void initState() {
    // TODO: implement initState
    initRecorder();
    Dashboard().fetchOIndividualLeads(widget.leadId);
    timeLineController.fetchTimeLine(widget.leadId);
    attachmentController.fetchAttachment();
    // fetchUserId();
    super.initState();
  }

  // fetchUserId() async {
  //   user_Id = await SharedPreference().getUserId();
  //   print('user_Id ========== $user_Id');
  // }

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
    print("file. path======>${file.path}");
    audioFileData = FileHelper.getBase64FormateFile(file.path);
    print("file. path======>$audioFileData");
    String fileName = file.path.split("/").last;
    // var customOrderUpdateResponse =
    // await FileUploadRepository().getCustomOrderResponse(
    //   base64File,
    //   fileName,
    // );
    // if (customOrderUpdateResponse.result == false) {
    //   ToastComponent.showDialog(
    //     customOrderUpdateResponse.message,
    //     gravity: Toast.center,
    //     duration: Toast.lengthLong,
    //   );
    //   return;
    // } else {
    //   ToastComponent.showDialog(
    //     customOrderUpdateResponse.message,
    //     gravity: Toast.center,
    //     duration: Toast.lengthLong,
    //   );
    //   refresh();
    //   // loadedAudio.add(customOrderUpdateResponse.path!);
    //   // _images.add(customOrderUpdateResponse.path!);
    //   setState(() {});
    // }
    setState(() {});
    print('Recorded file path: $filePath');
  }

  @override
  Widget build(BuildContext context) {
    // final LeadsController leadsController = Get.find();
    LeadsController leadsController = Get.put(LeadsController());
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
                    oldStatus = 12;
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
                          titleRow(
                              firstTitle: "Lead Name",
                              secondTitle: "Assigned to"),
                          SizedBox(
                            height: 10,
                          ),
                          subTitleRow(
                            firstSubTitle: leadDetails.name!,
                            secondSubTitle: 'Staff',
                            firstIcon: 'assets/image/person_icon.png',
                            secondIcon: 'assets/image/person_icon.png',
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          titleRow(firstTitle: "Email", secondTitle: "Phone"),
                          SizedBox(
                            height: 10,
                          ),
                          subTitleRow(
                              firstSubTitle: leadDetails.email!,
                              secondSubTitle: leadDetails.phoneNo!,
                              firstIcon: 'assets/image/message_icon.png',
                              secondIcon: 'assets/image/call_icon.png'),
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
                              firstIcon: 'assets/image/location_icon.png',
                              secondIcon: 'assets/image/instagram_icon.png'),
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
                              firstIcon: 'assets/image/calender_icon.png',
                              secondIcon: 'assets/image/calender_icon.png'),
                          SizedBox(
                            height: 15,
                          ),
                          titleRow(
                              firstTitle: "Status", secondTitle: "Designation"),
                          SizedBox(
                            height: 10,
                          ),
                          subTitleRow(
                              firstSubTitle: leadDetails.status!.toString(),
                              secondSubTitle: leadDetails.designation ?? "",
                              firstIcon: 'assets/image/status_icon.png',
                              secondIcon: 'assets/image/calender_icon.png'),

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
                            image: AssetImage("assets/image/call_icon.png"),
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
                              'assets/image/message_icon.png',
                            ),
                            color: Colors.red,
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
                                "assets/image/whatsapp_icon.png",
                              ))),
                        ),
                      ),
                      CustomText(
                        text: "Whatsapp",
                        color: Colors.red,
                      )
                    ],
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
                      readOnly: true,
                      onTap: () {
                        leadsController.pickFile();
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
                                (leads) =>
                                    leads.id ==
                                    leadsController.selectedLeadIds.value,
                                orElse: () => leadsController.leadStatusList[0],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        items: leadsController.leadStatusList.map((Data item) {
                          return DropdownMenuItem<Data>(
                            value: item,
                            child: Container(
                              width: 290,
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                        hint: Text('Select Product'),
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
                  CustomText(text: "Followup Notes"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 110,
                    child: CustomTextField(
                        controller: leadsController.followupNotesCon,
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
            CustomButton(
                buttonText: "Submit",
                onTap: () async {
                  String user_Id = await SharedPreference().getUserId();
                  LeadDatasCreate response = await Dashboard().postLeadDatas(
                      leadID,
                      int.parse(user_Id),
                      oldStatus,
                      1,
                      leadsController.followupNotesCon.text,
                      dates!,
                      leadsController.files!,
                      leadsController.lastCallRecording);

                  if (response.result == true) {
                    leadsController.clearAll();
                    ToastComponent.showDialog(response.message!,
                        gravity: Toast.center, duration: Toast.lengthLong);
                  }
                }),
            SizedBox(
              height: 20,
            ),
            Obx(() {
              return attachmentController.attachmentList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          CustomText(
                            text: "Attachment",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AttachmentScreen()));
                              },
                              child: CustomText(text: "View All"))
                        ],
                      ),
                    )
                  : Container();
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: attachmentController.attachmentList.length < 2
                      ? attachmentController.attachmentList.length
                      : 2,
                  itemBuilder: (context, index) {
                    final data = attachmentController.attachmentList[index];
                    return attachmentContainer(data);
                  });
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return timeLineController.activeTimeLineList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          CustomText(
                            text: "Activity TimeLine",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TimeLinePage()));
                              },
                              child: CustomText(text: "View All"))
                        ],
                      ),
                    )
                  : Container();
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: timeLineController.activeTimeLineList.length < 2
                      ? timeLineController.activeTimeLineList.length
                      : 2,
                  itemBuilder: (context, index) {
                    final data = timeLineController.activeTimeLineList[index];
                    return timeLineContainer(data);
                  });
            })
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
      required String firstIcon,
      required String secondIcon}) {
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
                    child: Image(image: AssetImage(firstIcon))),
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
                    child: Image(image: AssetImage(secondIcon))),
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
        onTap: onTap,
        decoration: InputDecoration(
          border: InputBorder.none,
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
