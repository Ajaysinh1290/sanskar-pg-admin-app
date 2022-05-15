import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/controller/add_hostel_controller.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';

class RoomRentInformation extends StatelessWidget {
  const RoomRentInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddHostelController>(builder: (addHostelController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Rent Information',
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
            hintText: 'None Ac Room Rent',
            prefixIconData: Icons.credit_card,
            controller: addHostelController.noneAcRoomRentController,
            isNumber: true,
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
              hintText: 'Ac Room Rent',
              prefixIconData: Icons.credit_card,
              controller: addHostelController.acRoomRentController,
              isNumber: true),
        ],
      );
    });
  }
}
