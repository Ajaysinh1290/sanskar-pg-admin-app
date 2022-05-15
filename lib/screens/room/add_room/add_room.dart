import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/models/room/room.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/widgets.dart';

import 'controller/add_room_controller.dart';

class AddRoom extends StatelessWidget {
  final Room? room;

  const AddRoom({Key? key, this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddRoomController addRoomController = Get.put(AddRoomController());
    addRoomController.room = room;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          room==null?'Add Room':'Edit Room',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AddRoomController>(builder: (addRoomController) {
        return SingleChildScrollView(
          child: Padding(
            padding: Constants.scaffoldPaddingWithoutSafeArea,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room Information',
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
                AnimatedUnderlineTextField(
                  hintText: 'Wing',
                  prefixIconData: Icons.location_city,
                  controller: addRoomController.wingController,
                ),
                SizedBox(
                  height: 15.h,
                ),
                AnimatedUnderlineTextField(
                  hintText: 'Floor',
                  isNumber: true,
                  prefixIconData: Icons.account_balance,
                  controller: addRoomController.floorController,
                ),
                SizedBox(
                  height: 15.h,
                ),
                AnimatedUnderlineTextField(
                  hintText: 'Room Number',
                  isNumber: true,
                  controller: addRoomController.roomNumberController,
                  prefixIconData: Icons.home,
                ),
                SizedBox(
                  height: 15.h,
                ),
                AnimatedUnderlineTextField(
                  hintText: 'Capacity',
                  isNumber: true,
                  prefixIconData: Icons.people,
                  controller: addRoomController.capacityController,
                ),
                SizedBox(
                  height: 15.h,
                ),
                MyDropDownMenuButton(
                  value: addRoomController.roomType,
                  onChanged: (value) {
                    addRoomController.roomType = value;
                  },
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        'Select Room Type',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'AC',
                      child: Text(
                        'AC',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'None AC',
                      child: Text(
                        'None AC',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        value: addRoomController.isActive,
                        onChanged: (value) {
                          addRoomController.isActive = value;
                        })
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Obx(
                  () => RoundedBorderButton(
                      onPressed: () {
                        if (addRoomController.validateData()) {
                          addRoomController.submitData();
                        }
                      },
                      isLoading: addRoomController.isLoading.value,
                      buttonText: room == null ? 'Add Room' : 'Update Room'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
