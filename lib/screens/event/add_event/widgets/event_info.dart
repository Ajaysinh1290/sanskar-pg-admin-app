import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/screens/event/add_event/controller/add_event_controller.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';

class EventInformation extends StatelessWidget {
  const EventInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddEventController>(builder: (addEventController) {
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
          AnimatedUnderlineTextField(
            hintText: 'Event Title',
            prefixIconData: Icons.calendar_today,
            controller: addEventController.eventTitleController,
          ),
          SizedBox(
            height: 15.h,
          ),
          AnimatedUnderlineTextField(
            hintText: 'Event Description',
            prefixIconData: Icons.assignment,
            controller: addEventController.eventDescriptionController,
            expanded: true,
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      );
    });
  }
}
