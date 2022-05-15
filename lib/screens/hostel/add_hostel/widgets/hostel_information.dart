import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/controller/add_hostel_controller.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';

class HostelInformation extends StatelessWidget {
  const HostelInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddHostelController>(builder: (addHostelController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hostel Information',
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
            hintText: 'Hostel Name',
            prefixIconData: Icons.account_balance_rounded,
            controller: addHostelController.hostelNameController,
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
            hintText: 'Mail',
            prefixIconData: Icons.mail,
            controller: addHostelController.mailController,
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
            hintText: 'Mobile Number',
            prefixIconData: Icons.call,
            controller: addHostelController.mobileNumberController,
          ),
        ],
      );
    });
  }
}
