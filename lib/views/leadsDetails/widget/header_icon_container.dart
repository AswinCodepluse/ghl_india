import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/views/attachment/attachment_screen.dart';
import 'package:ghl_callrecoding/views/call_log/call_log_screen.dart';
import 'package:ghl_callrecoding/views/document/document_screen.dart';
import 'package:ghl_callrecoding/views/time_line/time_line_page.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderIconContainer extends StatelessWidget {
  HeaderIconContainer(
      {super.key, required this.phoneNumber, required this.email});

  final String phoneNumber;
  final String email;

  final leadsController = Get.find<LeadsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: leadsController.shadow),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 75,
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
                        height: 30,
                        width: 30,
                        image: AssetImage(
                          "assets/image/call_icon.png",
                        ),
                      )),
                  SizedBox(
                    height: 2,
                  ),
                  CustomText(
                    text: "Call",
                  )
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      leadsController.openSMS(
                          context: context, phoneNumber: phoneNumber);
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image(
                        image: AssetImage(
                          'assets/image/message_icon.png',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  CustomText(
                    text: "Message",
                  )
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 75,
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
                      child: const SizedBox(
                          height: 35,
                          width: 35,
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
              width: 8,
            ),
            Container(
              width: 75,
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
                      child: const SizedBox(
                          height: 30,
                          width: 30,
                          child: Image(
                              image: AssetImage(
                            "assets/image/gmail_icon.png",
                          ))),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  CustomText(
                    text: "Gmail",
                    // color: Colors.red,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 75,
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
                      child: const SizedBox(
                          height: 34,
                          width: 34,
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
              width: 8,
            ),
            Container(
              width: 75,
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
                      child: const SizedBox(
                        height: 30,
                        width: 30,
                        child: Image(
                          image: AssetImage(
                            "assets/image/document_icon.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  CustomText(
                    text: "Documents",
                    // color: Colors.red,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CallLogScreen(
                                    leadPhoneNumber: phoneNumber,
                                  )));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(
                        height: 30,
                        width: 30,
                        child: Image(
                          image: AssetImage(
                            "assets/image/call_log_icon.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  CustomText(
                    text: "Call Log",
                    // color: Colors.red,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
