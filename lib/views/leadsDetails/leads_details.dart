import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';
import 'package:ghl_callrecoding/models/lead_details.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadDetailsScreen extends StatelessWidget {
  const LeadDetailsScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

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
            height: 100,
            child: FutureBuilder<LeadDetails>(
              future: Dashboard().fetchOIndividualLeads(phoneNumber),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: leadsController.pickFile,
                child: Icon(
                  Icons.upload_file,
                  size: 40,
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
                          image: AssetImage('assets/image/phone_icon.png'))),
                ),
              )
            ],
          ),
          Obx(() {
            return leadsController.fileName.value != ''
                ? Text(leadsController.fileName.value)
                : Container();
          }),
        ],
      ),
    );
  }
}
