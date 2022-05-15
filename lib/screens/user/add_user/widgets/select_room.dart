import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/room/room.dart';
import 'package:sanskar_pg_admin_app/widgets/drop_down_button/drop_down_button.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/add_user_controller.dart';

class SelectRoom extends StatelessWidget {
  const SelectRoom({Key? key}) : super(key: key);

  _pendingRent() {
    AddUserController  userController = Get.find();
    if(userController.user==null) {
      return 0;
    }
    var pendingRent = 0;
    int todayMonth = DateTime.now().month;
    int todayYear = DateTime.now().year;
    int curMonth = userController.user!.admissionDate!.month;
    int curYear = userController.user!.admissionDate!.year;

    while(todayYear!=curYear&&todayMonth!=curMonth) {

    }
  }
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> roomType = ValueNotifier('None AC');
    return GetBuilder<AddUserController>(builder: (addUserController) {
      return StreamBuilder<Object>(
          stream: FirebaseFirestore.instance
              .collection('hostels')
              .doc(Get.find<HostelController>().hostel!.hostelId)
              .collection('rooms')
              .where('isActive', isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            List<Room>? rooms;
            if (snapshot.hasData) {
              List data = snapshot.data.docs;
              rooms = [];
              for (var element in data) {
                Room room = Room.fromJson(element.data());
                if (room.roomId == addUserController.roomId) {
                  roomType.value = room.roomType;
                }
                if (room.users == null || room.users!.length < room.capacity) {
                  rooms.add(room);
                }
              }
              rooms.sort((a, b) => '${a.wing}-${a.floor}-${a.roomNumber}'
                  .compareTo('${b.wing}-${b.floor}-${b.roomNumber}'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room',
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Please fill in the details below',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  height: 50.h,
                ),
                rooms == null
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[100]!,
                        highlightColor: Colors.grey[200]!,
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          color: Theme.of(context).cardColor,
                        ),
                      )
                    : ValueListenableBuilder<String>(
                        valueListenable: roomType,
                        builder: (context, value, _) {
                          List<Room> sortedList = rooms!
                              .where((element) => element.roomType == value)
                              .toList();

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AbsorbPointer(
                                    absorbing : false,
                                    child: Text(
                                      'AC',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Checkbox(
                                      fillColor: MaterialStateProperty.all(
                                          Theme.of(context).primaryColor),
                                      value: roomType.value == 'AC',
                                      onChanged: (value) {
                                        addUserController.roomId = '';
                                        roomType.value =
                                            value ?? false ? 'AC' : "None AC";
                                      })
                                ],
                              ),
                              MyDropDownMenuButton(
                                value: addUserController.roomId,
                                onChanged: (value) {
                                  addUserController.roomId = value.toString();
                                },
                                items: [
                                  DropdownMenuItem(
                                      value: '',
                                      child: Text(
                                        'Select Room',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      )),
                                  for (Room room in sortedList)
                                    DropdownMenuItem(
                                        value: room.roomId,
                                        child: Text(
                                          '${room.wing}-${room.floor}-${room.roomNumber}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        )),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ],
            );
          });
    });
  }
}
