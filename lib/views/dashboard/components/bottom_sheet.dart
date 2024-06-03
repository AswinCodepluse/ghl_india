import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/views/dashboard/components/log_out_dialog.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

Future<void> bottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(40),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
