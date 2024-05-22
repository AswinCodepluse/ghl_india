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
  HeaderIconContainer({super.key, required this.phoneNumber});

  final String phoneNumber;

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
            Column(
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
                      height: 40,
                      image: AssetImage(
                        "assets/image/call_img.png",
                      ),
                    )),
                CustomText(
                  text: "Call",
                )
              ],
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    leadsController.openSMS(
                        context: context, phoneNumber: phoneNumber);
                  },
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Image(
                      image: AssetImage(
                        'assets/image/message_img.png',
                      ),
                    ),
                  ),
                ),
                CustomText(
                  text: "Message",
                  // color: Colors.red,
                )
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Column(
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
                  // color: Colors.red,
                )
              ],
            ),
            SizedBox(
              width: 8,
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
                  // color: Colors.red,
                )
              ],
            ),
            SizedBox(
              width: 8,
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
                  // color: Colors.red,
                )
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Column(
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
                      height: 40,
                      width: 40,
                      child: Image(
                        image: AssetImage(
                          "assets/image/document_icon.png",
                        ),
                      ),
                    ),
                  ),
                ),
                CustomText(
                  text: "Documents",
                  // color: Colors.red,
                )
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Column(
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
                      height: 40,
                      width: 40,
                      child: Image(
                        image: AssetImage(
                          "assets/image/document_icon.png",
                        ),
                      ),
                    ),
                  ),
                ),
                CustomText(
                  text: "Call Log",
                  // color: Colors.red,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
