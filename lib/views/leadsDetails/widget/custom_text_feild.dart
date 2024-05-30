import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/lead_details_controller.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.controller,
      this.onTap,
      this.suffixIcon,
      this.prefixIcon,
      this.maxLines,
      this.hintText,
      this.onChange,
      this.readOnly,
      this.keyboardType});

  final TextEditingController controller;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final String? hintText;
  final void Function(String)? onChange;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final leadsController = Get.find<LeadsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        cursorColor: Colors.grey,
        maxLines: maxLines ?? 1,
        // onChanged: dashboardController.searchLead,
        cursorHeight: 20,
        onChanged: onChange,
        keyboardType: keyboardType,
        onTap: onTap,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
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
          color: Colors.white,
          boxShadow: leadsController.shadow),
    );
  }
}
