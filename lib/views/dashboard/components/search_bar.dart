import 'package:flutter/material.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';

Widget searchBar(
    TextEditingController controller, DashboardController dashboardController) {
  return Container(
    height: 40,
    child: TextField(
      controller: controller,
      cursorColor: Colors.grey,
      onChanged: dashboardController.searchLead,
      cursorHeight: 20,
      decoration: InputDecoration(
        hintText: "Search...",
        border: InputBorder.none,
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            dashboardController.clearSearchText();
          },
          child: Icon(
            Icons.clear,
            color: Colors.grey,
          ),
        ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 0.1)),
  );
}
