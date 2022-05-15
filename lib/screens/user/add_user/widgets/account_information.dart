import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/date_time_picker/date_picker.dart';
import 'package:sanskar_pg_admin_app/widgets/drop_down_button/drop_down_button.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';

import '../controller/add_user_controller.dart';

class AccountInformation extends StatelessWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddUserController>(builder: (addUserController) {
      String dateOfBirth = addUserController.dateOfBirth == null
          ? ''
          : Constants.onlyDateFormat.format(addUserController.dateOfBirth!);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
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
            hintText: 'Name',
            prefixIconData: Icons.person,
            controller: addUserController.nameController,
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
            hintText: 'Mail',
            prefixIconData: Icons.mail,
            controller: addUserController.mailController,
          ),
          if (addUserController.user == null)
            SizedBox(
              height: 15.h,
            ),
          if (addUserController.user == null)
            AnimatedUnderlineTextField(
              hintText: 'Password',
              prefixIconData: Icons.lock,
              controller: addUserController.passwordController,
              obscureText: true,
            ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
            hintText: 'Mobile Number',
            prefixIconData: Icons.call,
            controller: addUserController.mobileNumberController,
          ),
          SizedBox(
            height: 15.h,
          ),
          InkWell(
            onTap: () async {
              addUserController.dateOfBirth = await pickDate(
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 150)),
                  lastDate: DateTime.now().subtract(
                    const Duration(days: 365 * 5),
                  ),
                  initialDate: addUserController.dateOfBirth == null
                      ? DateTime.now().subtract(const Duration(days: 365 * 18))
                      : DateTime.now());
            },
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedUnderlineTextField(
                hintText: 'Date of birth',
                readOnly: true,
                prefixIconData: Icons.date_range,
                controller: TextEditingController(text: dateOfBirth),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          MyDropDownMenuButton(
              value: addUserController.gender,
              onChanged: (value) {
                addUserController.gender = value as String;
              },
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(
                    'Select Gender',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Male',
                  child: Text(
                    'Male',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text(
                    'Female',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ]),
        ],
      );
    });
  }
}
