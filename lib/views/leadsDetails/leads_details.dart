import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/models/lead_details.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // final LeadsController leadsController = Get.find();
    LeadsController leadsController = Get.put(LeadsController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Details'),
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration:
                BoxDecoration(color: Color(0XFFFCE9E9), shape: BoxShape.circle),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firstLetter,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  lastLetter,
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
            height: 20,
          ),
          Text("Customer Service Manager"),
          Container(
            height: 100,
            child: FutureBuilder(
              future: Dashboard().fetchOIndividualLeads(leadId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  LeadDetails leadDetails = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 300,
                            child:
                                CustomText(text: 'Name: ${leadDetails.name}')),
                        SizedBox(
                            width: 300,
                            child: CustomText(
                                text: 'Email: ${leadDetails.email}')),
                        SizedBox(
                          width: 300,
                          child: CustomText(
                              text: 'Phone Number: ${leadDetails.phoneNo}'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            height: 90,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: MyTheme.medium_grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: leadsController.pickFile,
                  child: Icon(
                    Icons.upload_file,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () async {
                      final call = Uri.parse('tel:+91 ${phoneNumber}');
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
                          'assets/image/phone_icon.png',
                        ),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    leadsController.openWhatsApp(context, phoneNumber);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    padding: const EdgeInsets.all(0),
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
                    child: const CircleAvatar(
                      backgroundImage: AssetImage("assets/image/whatsapp.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Activities",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  return leadsController.fileName.value != ''
                      ? Text(
                          leadsController.fileName.value,
                        )
                      : Container();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
