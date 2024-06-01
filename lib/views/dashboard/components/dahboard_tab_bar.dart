import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/firebase/firebase_repository.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/utils/colors.dart';
import 'package:ghl_callrecoding/utils/shared_value.dart';
import 'package:ghl_callrecoding/views/dashboard/components/bottom_sheet.dart';
import 'package:ghl_callrecoding/views/dashboard/components/exist_conformation_dailog.dart';
import 'package:ghl_callrecoding/views/dashboard/today_dashboard.dart';
import 'package:ghl_callrecoding/views/dashboard/total_dashboard.dart';
import 'package:ghl_callrecoding/views/recording_files/file_screen.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';

class DashBoardTabBar extends StatefulWidget {
  @override
  _DashBoardTabBarState createState() => _DashBoardTabBarState();
}

class _DashBoardTabBarState extends State<DashBoardTabBar>
    with SingleTickerProviderStateMixin {
  final DashboardController dashboardController = Get.put(DashboardController());
  late TabController _tabController;
  String userName = '';
  SharedPreference sharedPreference = SharedPreference();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    FirebaseRepository().setupInteractMessage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await exitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(text: "hello, ${user_name.$}"),
          leading: GestureDetector(
              onTap: () {
                bottomSheet(context);
              },
              child: Icon(Icons.menu)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0),
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,

            tabs: [
              Tab(text: 'Today Leads'),
              Tab(text: 'Total Leads'),
            ],
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: MyTheme.mainColor,

            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 14.0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            TodayDashBoardScreen(seasons: 'today'),
            TotalDashBoardScreen(seasons: 'total')
          ],
        ),
      ),
    );
  }
}
