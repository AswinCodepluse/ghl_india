// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
// import 'package:ghl_callrecoding/helpers/auth_helpers.dart';
// import 'package:ghl_callrecoding/local_db/shared_preference.dart';
// import 'package:ghl_callrecoding/repositories/all_leads_repositories.dart';
// import 'package:ghl_callrecoding/repositories/auth_repositories.dart';
// import 'package:ghl_callrecoding/utils/toast_component.dart';
// import 'package:ghl_callrecoding/views/auth/login_page.dart';
// import 'package:ghl_callrecoding/views/dashboard/dashboard.dart';
// import 'package:ghl_callrecoding/views/leadsDetails/widget/custom_text_feild.dart';
// import 'package:ghl_callrecoding/views/widget/custom_text.dart';
// import 'package:toast/toast.dart';
//
// class OnBoardScreen extends StatelessWidget {
//   OnBoardScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: CustomText(
//           text: "GHL India",
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(screenWidth / 18),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DashBoardScreen(seasons: 'today'),
//                   ),
//                 );
//               },
//               child: Stack(
//                 children: [
//                   Image(image: AssetImage("assets/image/bg_red_img.png")),
//                   Positioned(
//                       top: screenWidth / 9,
//                       right: screenWidth / 2.9,
//                       child: Image(
//                         image: AssetImage("assets/image/today_leads_icon.png"),
//                       )),
//                   Positioned(
//                       top: screenWidth / 2.8,
//                       right: screenWidth / 12,
//                       child: CustomText(
//                         text: "Today Leads",
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: screenWidth / 8,
//                       )),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DashBoardScreen(seasons: ''),
//                   ),
//                 );
//               },
//               child: Stack(
//                 children: [
//                   Image(image: AssetImage("assets/image/bg_blue_img.png")),
//                   Positioned(
//                       top: screenWidth / 9,
//                       right: screenWidth / 2.9,
//                       child: Image(
//                         image: AssetImage("assets/image/total_leads_icon.png"),
//                       )),
//                   Positioned(
//                       top: screenWidth / 2.8,
//                       right: screenWidth / 12,
//                       child: CustomText(
//                         text: "Total Leads",
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: screenWidth / 8,
//                       )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//               ),
//               child: Text(
//                 'GHL India Pvt Ltd',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: const Text('Logout'),
//               onTap: () {
//                 onTapLogout(context);
//               },
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.all(8.0),
//             //   child: CustomText(text: "Call Recording Path Storing"),
//             // ),
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             //   child: CustomTextField(
//             //     readOnly: true,
//             //     controller: dashboardController.callRecordingFileCon,
//             //     hintText: "Choose File Path",
//             //     onTap: () {
//             //       dashboardController.pickFile();
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   onTapLogout(context) async {
//     var logoutResponse = await AuthRepository().getLogoutResponse();
//     if (logoutResponse.result == true) {
//       AuthHelper().clearUserData();
//       await SharedPreference().clearUserData();
//       ToastComponent.showDialog(logoutResponse.message!.toString(),
//           gravity: Toast.center, duration: Toast.lengthLong);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LoginPage(),
//         ),
//       );
//     } else {
//       ToastComponent.showDialog(logoutResponse.message!.toString(),
//           gravity: Toast.center, duration: Toast.lengthLong);
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/helpers/auth_helpers.dart';
import 'package:ghl_callrecoding/local_db/shared_preference.dart';
import 'package:ghl_callrecoding/repositories/auth_repositories.dart';
import 'package:ghl_callrecoding/utils/toast_component.dart';
import 'package:ghl_callrecoding/views/auth/login_page.dart';
import 'package:ghl_callrecoding/views/dashboard/dashboard.dart';
import 'package:ghl_callrecoding/views/recording_files/file_screen.dart';
import 'package:ghl_callrecoding/views/widget/custom_text.dart';
import 'package:toast/toast.dart';

class DashBoardTabBar extends StatefulWidget {
  @override
  _DashBoardTabBarState createState() => _DashBoardTabBarState();
}

class _DashBoardTabBarState extends State<DashBoardTabBar>
    with SingleTickerProviderStateMixin {
  final DashboardController dashboardController = Get.find();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(Duration(seconds: 1), () {
      dashboardController.checkPermission();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Dashboard'),
        // leading: GestureDetector(
        //     onTap: () {
        //       bottomSheet();
        //     },
        //     child: Icon(Icons.menu)),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => FileScreen());
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.file_copy),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Today Leads'),
            Tab(text: 'Total Leads'),
          ],
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.red,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 14.0),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(5.0),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DashBoardScreen(seasons: 'today'),
          DashBoardScreen(seasons: 'total')
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'GHL India Pvt Ltd',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                onTapLogout(context);
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: CustomText(text: "Call Recording Path Storing"),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: CustomTextField(
            //     readOnly: true,
            //     controller: dashboardController.callRecordingFileCon,
            //     hintText: "Choose File Path",
            //     onTap: () {
            //       dashboardController.pickFile();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  onTapLogout(context) async {
    var logoutResponse = await AuthRepository().getLogoutResponse();
    if (logoutResponse.result == true) {
      AuthHelper().clearUserData();
      await SharedPreference().clearUserData();
      ToastComponent.showDialog(logoutResponse.message!.toString(),
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      ToastComponent.showDialog(logoutResponse.message!.toString(),
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

// Future<void> bottomSheet() {
//   return showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           child: CustomText(text: "Log Out"),
//           color: Colors.red,
//         );
//       });
// }
}
