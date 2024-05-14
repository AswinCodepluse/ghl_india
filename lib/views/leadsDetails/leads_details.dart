import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/common/custom_button.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/helpers/file_helper.dart';

import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen(
      {super.key,
      required this.phoneNumber,
      required this.firstLetter,
      required this.lastLetter,
      required this.leadId});

  final String phoneNumber;
  final String firstLetter;
  final String lastLetter;
  final int leadId;

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  String audioFileData = '';

  @override
  void initState() {
    // TODO: implement initState
    initRecorder();
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
              text: "Lead 1",
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            SizedBox(
              height: 10,
            ),
            CustomText(
              text: "Customer Service Manager",
              color: Colors.grey,
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   height: 100,
            //   child: FutureBuilder(
            //     future: Dashboard().fetchOIndividualLeads(leadId),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Center(
            //             child: CircularProgressIndicator(
            //           color: Colors.black,
            //         ));
            //       } else if (snapshot.hasError) {
            //         return Center(child: Text('Error: ${snapshot.error}'));
            //       } else {
            //         LeadDetails leadDetails = snapshot.data!;
            //         return Padding(
            //           padding: const EdgeInsets.all(16.0),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               SizedBox(
            //                   width: 300,
            //                   child:
            //                       CustomText(text: 'Name: ${leadDetails.name}')),
            //               SizedBox(
            //                   width: 300,
            //                   child: CustomText(
            //                       text: 'Email: ${leadDetails.email}')),
            //               SizedBox(
            //                 width: 300,
            //                 child: CustomText(
            //                     text: 'Phone Number: ${leadDetails.phoneNo}'),
            //               ),
            //             ],
            //           ),
            //         );
            //       }
            //     },
            //   ),
            // ),
            titleRow(firstTitle: "Lead Name", secondTitle: "Assigned to"),
            SizedBox(
              height: 10,
            ),

            subTitleRowWithProfileIcon(
                firstSubTitle: 'Lead 1',
                secondSubTitle: 'Staff',
                firstIcon: '',
                secondIcon: ''),
            SizedBox(
              height: 15,
            ),
            titleRow(firstTitle: "Email", secondTitle: "Phone"),
            SizedBox(
              height: 10,
            ),
            subTitleRow(
                firstSubTitle: 'lead222@gmail.comlead222',
                secondSubTitle: '7373256253',
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
                firstSubTitle: 'Google',
                secondSubTitle: 'Instagram',
                firstIcon: 'assets/image/location_icon.png',
                secondIcon: 'assets/image/instagram_icon.png'),
            SizedBox(
              height: 15,
            ),
            titleRow(firstTitle: "Created On", secondTitle: "Updated On"),
            SizedBox(
              height: 10,
            ),
            subTitleRow(
                firstSubTitle: '12-May-2024',
                secondSubTitle: '14-May-2024',
                firstIcon: 'assets/image/calender_icon.png',
                secondIcon: 'assets/image/calender_icon.png'),
            SizedBox(
              height: 15,
            ),
            titleRow(firstTitle: "Status", secondTitle: "Designation"),
            SizedBox(
              height: 10,
            ),
            subTitleRow(
                firstSubTitle: 'Yet to Call',
                secondSubTitle: '',
                firstIcon: 'assets/image/status_icon.png',
                secondIcon: 'assets/image/calender_icon.png'),

            SizedBox(
              height: 20,
            ),
            Container(
              height: 90,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: MyTheme.medium_grey, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                          onTap: leadsController.pickFile,
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
                          final call =
                              Uri.parse('tel:+91 ${widget.phoneNumber}');
                          if (await canLaunchUrl(call)) {
                            launchUrl(call);
                          } else {
                            throw 'Could not launch $call';
                          }
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
                    child: Obx(
                      () => DropdownButton<String>(
                        value:
                            leadsController.selectedLeadStatus.value.isNotEmpty
                                ? leadsController.selectedLeadStatus.value
                                : null,
                        borderRadius: BorderRadius.circular(10),
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: leadsController
                                    .selectedLeadStatus.value.isNotEmpty
                                ? leadsController.selectedLeadStatus.value
                                : null,
                            child: Text('Select Product'),
                          ),
                          ...leadsController.leadStatusNameList
                              .map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Container(
                                width: 300,
                                height: 60,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(item),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        onTap: () {
                          leadsController.fetchLeadStatus();
                          print('clicked');
                        },
                        onChanged: (value) {
                          if (value != null) {
                            leadsController.selectedLeadStatus.value = value;
                            print('===========================');
                            print(leadsController.selectedLeadStatus.value);
                            print('===========================');
                          }
                        },
                        hint: Text('Select Product'),
                        style: TextStyle(
                          color: MyTheme.medium_grey,
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
                  InkWell(
                    onTap: () async {
                      if (recorder.isRecording) {
                        await stopRecorder();
                        setState(() {});
                      } else {
                        await startRecord();
                        setState(() {});
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Sent Voice",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: MyTheme.dark_font_grey),
                          ),
                          Icon(
                            recorder.isRecording ? Icons.stop : Icons.mic,
                            size: 18,
                            color: MyTheme.dark_font_grey,
                          )
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
            CustomButton(buttonText: "Submit", onTap: () {}),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget titleRow({required String firstTitle, required String secondTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
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
            width: 155,
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
            width: 155,
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

  Widget subTitleRowWithProfileIcon(
      {required String firstSubTitle,
      required String secondSubTitle,
      required String firstIcon,
      required String secondIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          SizedBox(
            width: 155,
            child: Row(
              children: [
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text('lsss')),
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
            width: 155,
            child: Row(
              children: [
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text('ls')),
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
          border: Border.all(color: Colors.grey, width: 0.1)),
    );
  }
}
