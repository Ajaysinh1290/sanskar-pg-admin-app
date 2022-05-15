import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/controllers/dashboard_controller.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/screens/fees/transactions.dart';
import 'package:sanskar_pg_admin_app/screens/food/add_food/add_food.dart';
import 'package:sanskar_pg_admin_app/screens/food/foods.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/add_hostel.dart';
import 'package:sanskar_pg_admin_app/screens/offer/offers.dart';
import 'package:sanskar_pg_admin_app/screens/room/add_room/add_room.dart';
import 'package:sanskar_pg_admin_app/screens/room/rooms_screen.dart';
import 'package:sanskar_pg_admin_app/screens/user/add_user/add_user.dart';
import 'package:sanskar_pg_admin_app/screens/user/pending_requests.dart';
import 'package:sanskar_pg_admin_app/screens/user/users_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  getListTile(
      {required IconData icon,
      required String text,
      required Function() onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 26.sp,
        color: Colors.black,
      ),
      title: Text(
        text,
        style: Theme.of(Get.context!).textTheme.headline4,
      ),
    );
  }

  getTitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        text,
        style: Theme.of(Get.context!).textTheme.subtitle1,
      ),
    );
  }

  getOtherHostels(BuildContext context, HostelController hostelController,
      DashboardController dashboardController) {
    List<Widget> widgetsList = [];

    for (int i = 0; i < hostelController.hostels.length; i++) {
      if (i != hostelController.currentHostel) {
        widgetsList.add(
          InkWell(
            onTap: () {
              hostelController.currentHostel = i;
              dashboardController.showAllHostel = false;
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  Container(
                    width: 50.w,
                    height: 50.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    child: Text(
                      hostelController.hostels[i].hostelName.substring(0, 1),
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hostelController.hostels[i].hostelName,
                          style: Theme.of(context).textTheme.headline4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(
                          hostelController.hostels[i].emailId,
                          style: Theme.of(context).textTheme.subtitle1,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
                  )
                ],
              ),
            ),
          ),
        );
      }
    }
    widgetsList.add(Padding(
      padding: const EdgeInsets.only(left: 8),
      child: getListTile(
          icon: Icons.add,
          text: 'Add Hostel',
          onTap: () {
            Get.to(const AddHostel(), transition: Transition.rightToLeft);
          }),
    ));
    return Column(
      children: widgetsList,
    );
  }

  @override
  Widget build(BuildContext context) {
    HostelController hostelController = Get.find();
    DashboardController dashboardController = Get.find();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                dashboardController.showAllHostel =
                    !dashboardController.showAllHostel;
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  Container(
                    width: 50.w,
                    height: 50.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    child: Text(
                      hostelController
                          .hostels[hostelController.currentHostel].hostelName
                          .substring(0, 1),
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hostelController
                              .hostels[hostelController.currentHostel]
                              .hostelName,
                          style: Theme.of(context).textTheme.headline4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          hostelController
                              .hostels[hostelController.currentHostel].emailId,
                          style: Theme.of(context).textTheme.subtitle1,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Obx(() => Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          dashboardController.showAllHostel
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down_outlined,
                          size: 30.sp,
                          color: Colors.black,
                        ),
                      ))
                ],
              ),
            ),

            Obx(
              () => dashboardController.showAllHostel
                  ? getOtherHostels(
                      context, hostelController, dashboardController)
                  : Container(),
            ),
            // Obx(
            //       () =>
            //   dashboardController.showAllHostel
            //       ? getOtherHostels(context, hostelController)
            //       : Container(),
            // ),

            SizedBox(
              height: 10.h,
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              height: 2,
              width: double.infinity,
              color: Theme.of(context).dividerColor.withOpacity(0.3),
            ),
            getTitle('USERS'),
            getListTile(
                icon: Icons.person_add,
                text: 'Add User',
                onTap: () => Get.to(const AddUser(),
                    transition: Transition.rightToLeft)),
            getListTile(
                icon: Icons.people,
                text: 'Users',
                onTap: () {
                  Get.to(UsersScreen(), transition: Transition.rightToLeft);
                }),
            getListTile(
                icon: Icons.access_time_outlined,
                text: 'Pending Requests',
                onTap: () {
                  Get.to(const PendingRequests(),
                      transition: Transition.rightToLeft);
                }),
            getTitle('ROOMS'),
            getListTile(
                icon: Icons.add_to_photos_sharp,
                text: 'Add Room',
                onTap: () => Get.to(const AddRoom(),
                    transition: Transition.rightToLeft)),
            getListTile(
                icon: Icons.account_balance,
                text: 'Rooms',
                onTap: () => Get.to(const RoomsScreen(),
                    transition: Transition.rightToLeft)),
            getTitle('CANTEEN'),
            getListTile(
                icon: Icons.add_box_rounded,
                text: 'Add Food',
                onTap: () {
                  Get.to(const AddFood(), transition: Transition.rightToLeft);
                }),
            getListTile(
                icon: Icons.fastfood,
                text: 'Foods',
                onTap: () {
                  Get.to(const Foods(), transition: Transition.rightToLeft);
                }),
            getTitle('RENTS'),
            getListTile(
                icon: Icons.compare_arrows,
                text: 'Transactions',
                onTap: () => Get.to(const Transactions(),
                    transition: Transition.rightToLeft)),
            getListTile(
                icon: Icons.local_offer,
                text: 'Offers',
                onTap: () {
                  Get.to(const OffersScreen(),
                      transition: Transition.rightToLeft);
                }),
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: Text(
                'VERSION 1.0.0',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
