import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/views/attachment/attachment_screen.dart';
import 'package:ghl_callrecoding/views/call_log/call_log_screen.dart';
import 'package:ghl_callrecoding/views/document/document_screen.dart';
import 'package:ghl_callrecoding/views/leadsDetails/widget/report_alert.dart';
import 'package:ghl_callrecoding/views/time_line/time_line_page.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderIconContainer extends StatelessWidget {
  HeaderIconContainer(
      {super.key,
      required this.phoneNumber,
      required this.email,
      required this.leadId,
      required this.screenWidth,
      required this.leadsController});

  final String phoneNumber;
  final String email;
  final int leadId;
  final double screenWidth;
  final LeadsController leadsController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth / 36),
      margin: EdgeInsets.symmetric(horizontal: screenWidth / 24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth / 24),
          boxShadow: [
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
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth / 5.14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          final call = Uri.parse('tel:+91 ${phoneNumber}');
                          if (await canLaunchUrl(call)) {
                            launchUrl(call);
                          } else {
                            throw 'Could not launch $call';
                          }
                        },
                        child: Image(
                          height: screenWidth / 12,
                          width: screenWidth / 12,
                          image: AssetImage(
                            "assets/image/call_icon.png",
                          ),
                        )),
                    SizedBox(
                      height: screenWidth / 180,
                    ),
                    CustomText(
                      text: "Call",
                    )
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth / 72,
              ),
              Container(
                width: screenWidth / 4.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        leadsController.openSMS(
                            context: context, phoneNumber: phoneNumber);
                      },
                      child: SizedBox(
                        height: screenWidth / 12,
                        width: screenWidth / 12,
                        child: Image(
                          image: AssetImage(
                            'assets/image/message_icon.png',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenWidth / 180,
                    ),
                    CustomText(
                      text: "Message",
                    )
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth / 45,
              ),
              Container(
                width: screenWidth / 5.14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        leadsController.openWhatsApp(context, phoneNumber);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                            height: screenWidth / 10.28,
                            width: screenWidth / 10.28,
                            child: Image(
                                image: AssetImage(
                              "assets/image/whatsapp_icon.png",
                            ))),
                      ),
                    ),
                    CustomText(
                      text: "Whatsapp",
                    )
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth / 180,
              ),
              Container(
                width: screenWidth / 4.61,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        leadsController.launchEmail(email);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                            height: screenWidth / 12,
                            width: screenWidth / 12,
                            child: Image(
                                image: AssetImage(
                              "assets/image/gmail_icon.png",
                            ))),
                      ),
                    ),
                    SizedBox(
                      height: screenWidth / 180,
                    ),
                    CustomText(
                      text: "Gmail",
                      // color: Colors.red,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenWidth / 36,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth / 5.14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        child: SizedBox(
                            height: screenWidth / 10.58,
                            width: screenWidth / 10.58,
                            child: Image(
                                image: AssetImage(
                              "assets/image/activity_icon.png",
                            ))),
                      ),
                    ),
                    CustomText(
                      text: "Activities",
                      // color: Colors.red,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth / 45,
              ),
              Container(
                width: screenWidth / 4.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocumentScreen(
                                      phoneNUmber: phoneNumber,
                                    )));
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          height: screenWidth / 12,
                          width: screenWidth / 12,
                          child: Image(
                            image: AssetImage(
                              "assets/image/document_icon.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenWidth / 180,
                    ),
                    CustomText(
                      text: "Documents",
                      // color: Colors.red,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth / 45,
              ),
              Container(
                width: screenWidth / 5.14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CallLogScreen(
                                      leadPhoneNumber: phoneNumber, leadId: leadId.toString(),
                                    )));
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          height: screenWidth / 12,
                          width: screenWidth / 12,
                          child: Image(
                            image: AssetImage(
                              "assets/image/call_log_icon.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenWidth / 180,
                    ),
                    CustomText(
                      text: "Call Log",
                      // color: Colors.red,
                    )
                  ],
                ),
              ),
              Container(
                width: screenWidth / 4.61,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        reportAlertDialog(context, leadId);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                            height: screenWidth / 12,
                            width: screenWidth / 12,
                            child: Image(
                                image: AssetImage(
                              "assets/image/report_icon.png",
                            ))),
                      ),
                    ),
                    SizedBox(
                      height: screenWidth / 180,
                    ),
                    CustomText(
                      text: "Report",
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
