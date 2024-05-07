import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
import 'package:ghl_callrecoding/models/all_leads_models.dart';
import 'package:ghl_callrecoding/views/leadsDetails/leads_details.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  Color getColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      case 'brown':
        return Colors.brown;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(Icons.menu)),
        title: const Text('Leads'),
        actions: [
          GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.search),
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                  itemCount: dashboardController.leadsList.length,
                  itemBuilder: (context, index) {
                    final data = dashboardController.leadsList[index];
                    final randomColor = dashboardController.colors[
                        Random().nextInt(dashboardController.colors.length)];
                    return leadsContainer(data, randomColor);
                  });
            }),
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
              title: const Text('Item 1'),
              onTap: () {

                Navigator.pop(context);
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

  Widget leadsContainer(AllLeads data, String randomColor) {
    String firstLetter = data.name!.substring(0, 1).toUpperCase();
    String lastLetter =
        data.name!.substring(data.name!.length - 1).toUpperCase();
    return GestureDetector(
      onTap: () {
        Get.to(
          () => LeadDetailsScreen(
            phoneNumber: data.phoneNo,
          ),
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
                  color: getColor(randomColor), shape: BoxShape.circle),
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
                customText(
                    text: data.name ?? '',
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
                customText(text: data.phoneNo ?? ''),
                customText(text: data.email ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget customText(
    {required String text, double? fontSize, FontWeight? fontWeight}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ghl_callrecoding/controllers/dashboard_controller.dart';
// import 'package:ghl_callrecoding/models/lead_details.dart';
//
// import '../leadsDetails/leads_details.dart';
// import 'components/avatar_widget.dart';
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   final DashboardController dashboardController =
//       Get.put(DashboardController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Leads"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {},
//         ),
//       ),
//       body: ListenableBuilder(
//         listenable: dashboardController,
//         builder: (context, child) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.separated(
//                     separatorBuilder: (context, index) {
//                       return const SizedBox(
//                         height: 10,
//                         width: 10,
//                       );
//                     },
//                     itemCount: dashboardController.leadsList.length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {
//                           Get.to(
//                             () => LeadDetailsScreen(
//                               phoneNumber:
//                                   dashboardController.leadsList[index].phoneNo,
//                             ),
//                           );
//                         },
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(10),
//                           shape: const Border.fromBorderSide(
//                             BorderSide(style: BorderStyle.solid),
//                           ),
//                           leading: AvatarWithName(
//                             name: dashboardController.leadsList[index].name!,
//                           ),
//                           title: Text(
//                             dashboardController.leadsList[index].name!,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
