import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';

import '../controller/add_user_controller.dart';

class AddUserAddress extends StatelessWidget {
  const AddUserAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddUserController>(builder: (addUserController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address',
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
            hintText: 'Street Address',
            prefixIconData: Icons.home,
            controller: addUserController.streetAddressController,
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
            hintText: 'City',
            prefixIconData: Icons.location_city,
            controller: addUserController.cityAddressController,
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
            hintText: 'State',
            prefixIconData: Icons.near_me,
            controller: addUserController.stateAddressController,
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
            hintText: 'Pin Code',
            prefixIconData: Icons.location_on_sharp,
            controller: addUserController.pinCodeAddressController,
          ),
        ],
      );
    });
  }
}
