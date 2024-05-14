import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/views/dashboard/components/search_bar.dart';
import 'package:ghl_callrecoding/views/leadsDetails/leads_details.dart';
import 'package:ghl_callrecoding/views/recording_files/file_screen.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

import '../../helpers/auth_helpers.dart';
import '../../utils/shared_value.dart';
import '../auth/login_page.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => FileScreen());
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.file_copy),
              )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child:
                searchBar(dashboardController.searchCon, dashboardController),
          ),
          Expanded(
            child: GetBuilder<DashboardController>(
              builder: (dashboardController){
                return dashboardController.isLeads.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : dashboardController.searchCon.text.isNotEmpty &&
                            dashboardController.searchLeadsList.isEmpty
                        ? Center(
                            child: CustomText(
                            text: "No Search Lead Found",
                          ))
                        : ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount:
                                dashboardController.searchCon.text.isNotEmpty
                                    ? dashboardController.searchLeadsList.length
                                    : dashboardController.leadsList.length,
                            itemBuilder: (context, index) {
                              final data = dashboardController
                                      .searchCon.text.isNotEmpty
                                  ? dashboardController.searchLeadsList[index]
                                  : dashboardController.leadsList[index];
                              final randomColor = dashboardController.colors[
                                  Random().nextInt(
                                      dashboardController.colors.length)];
                              return leadsContainer(
                                  data, randomColor, dashboardController);
                            });
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                if (is_logged_in.$)
                  onTapLogout(context);
                else
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  onTapLogout(context) async {
    AuthHelper().clearUserData();

    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
    //   return Main();
    // }), (route) => false);
  }

  Widget leadsContainer(AllLeads data, String randomColor,
      DashboardController dashboardController) {
    String firstLetter = data.name!.substring(0, 1).toUpperCase();
    String lastLetter =
        data.name!.substring(data.name!.length - 1).toUpperCase();
    return GestureDetector(
      onTap: () {
        Get.to(
          () => LeadDetailsScreen(
              phoneNumber: data.phoneNo!,
              firstLetter: firstLetter,
              lastLetter: lastLetter,
              leadId: data.id!),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  color: dashboardController.getColor(randomColor),
                  shape: BoxShape.circle),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    firstLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    lastLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: CustomText(
                      text: data.name ?? '',
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                    width: 220, child: CustomText(text: data.phoneNo ?? '')),
                SizedBox(width: 220, child: CustomText(text: data.email ?? '')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
