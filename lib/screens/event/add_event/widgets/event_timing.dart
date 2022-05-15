import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/screens/event/add_event/controller/add_event_controller.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/date_time_picker/date_picker.dart';
import 'package:sanskar_pg_admin_app/widgets/date_time_picker/time_picker.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';

class EventTiming extends StatelessWidget {
  const EventTiming({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddEventController>(builder: (addEventController) {
      DateTime now = DateTime.now();
      String startingDate = addEventController.startingDate == null
          ? ''
          : Constants.onlyDateFormat.format(addEventController.startingDate!);
      String endingDate = addEventController.endingDate == null
          ? ''
          : Constants.onlyDateFormat.format(addEventController.endingDate!);
      String startingTime = addEventController.startingTime == null
          ? ''
          : Constants.onlyTimeFormat.format(addEventController.startingTime!);
      String endingTime = addEventController.endingTime == null
          ? ''
          : Constants.onlyTimeFormat.format(addEventController.endingTime!);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Information',
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
          InkWell(
            onTap: () async {
              addEventController.startingDate = await pickDate(
                      firstDate: addEventController.startingDate??DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 100),
                      ),
                      initialDate: addEventController.startingDate) ??
                  addEventController.startingDate;
            },
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedUnderlineTextField(
                hintText: 'Starting Date',
                readOnly: true,
                prefixIconData: Icons.date_range,
                controller: TextEditingController(text: startingDate),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          InkWell(
            onTap: () async {
              addEventController.endingDate = await pickDate(
                      firstDate: addEventController.endingDate??DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 100),
                      ),
                      initialDate: addEventController.endingDate) ??
                  addEventController.endingDate;
            },
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedUnderlineTextField(
                hintText: 'Ending Date',
                readOnly: true,
                prefixIconData: Icons.date_range,
                controller: TextEditingController(text: endingDate),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          InkWell(
            onTap: () async {
              TimeOfDay? pickedStartingTime = await pickTime(
                  initialTime: addEventController.startingTime != null
                      ? TimeOfDay(
                          hour: addEventController.startingTime!.hour,
                          minute: addEventController.startingTime!.minute)
                      : null);
              if (pickedStartingTime != null) {
                addEventController.startingTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    pickedStartingTime.hour,
                    pickedStartingTime.minute);
              }
            },
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedUnderlineTextField(
                hintText: 'Starting Time',
                readOnly: true,
                prefixIconData: Icons.date_range,
                controller: TextEditingController(text: startingTime),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          InkWell(
            onTap: () async {
              TimeOfDay? pickedEndingTime = await pickTime(
                  initialTime: addEventController.endingTime != null
                      ? TimeOfDay(
                          hour: addEventController.endingTime!.hour,
                          minute: addEventController.endingTime!.minute)
                      : null);
              if (pickedEndingTime != null) {
                addEventController.endingTime = DateTime(now.year, now.month,
                    now.day, pickedEndingTime.hour, pickedEndingTime.minute);
              }
            },
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedUnderlineTextField(
                hintText: 'Ending Time',
                readOnly: true,
                prefixIconData: Icons.date_range,
                controller: TextEditingController(text: endingTime),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      );
    });
  }
}
