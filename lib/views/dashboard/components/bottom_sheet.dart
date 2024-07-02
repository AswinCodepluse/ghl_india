import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/utils/custom_text_field.dart';
import 'package:ghl_callrecoding/views/dashboard/components/log_out_dialog.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Future<void> bottomSheet(BuildContext context,DashboardController controller) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(40),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(text: 'Select Call Recording Folder Path'),
              SizedBox(
                height: 5,
              ),
              CustomTextField(
                  controller: controller.callRecordingFolderCon,
                  readOnly: true,
                  hintText: "Call Recording Folder Path",
                  // onChange: (String value) {
                  //   leadsController.isDisable();
                  // },
                  onTap: () {
                    controller.pickFolderPath(context);
                  },
                  prefixIcon: Image(
                      image: AssetImage("assets/image/file_icon.png"))),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showLogoutDialog(context);
                },
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: MyTheme.mainColor, shape: BoxShape.circle),
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    CustomText(
                      text: "Log Out",
                      fontSize: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          )),
        );
      });
}
