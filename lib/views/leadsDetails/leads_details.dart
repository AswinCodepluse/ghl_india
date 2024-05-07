import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/models/lead_details.dart';
import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadDetailsScreen extends StatefulWidget {
  String? phoneNumber;

  LeadDetailsScreen({super.key, required this.phoneNumber});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  String? fileName;
  bool isPhone = false;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        fileName =
            file.path.split('/').last; // Extracting the file name from the path
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Details'),
      ),
      body: Container(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<LeadDetails>(
                future: Dashboard().fetchOIndividualLeads(widget.phoneNumber),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    LeadDetails leadDetails = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${leadDetails.name}'),
                          Text('Email: ${leadDetails.email}'),
                          Text('Phone Number: ${leadDetails.phoneNo}'),

                          // Add more fields as needed
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            !isPhone
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          isPhone = true;
                        });

                        final call = Uri.parse('tel:+91 ${widget.phoneNumber}');
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
                              image:
                                  AssetImage('assets/image/phone_icon.png'))),
                    ),
                  )
                : Column(
                    children: [
                      GestureDetector(
                        onTap: pickFile,
                        child: Icon(Icons.upload_file),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        fileName ?? 'No file selected',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
