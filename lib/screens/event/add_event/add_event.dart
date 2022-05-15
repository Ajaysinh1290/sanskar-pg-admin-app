import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/models/event/event.dart';
import 'package:sanskar_pg_admin_app/screens/event/add_event/controller/add_event_controller.dart';
import 'package:sanskar_pg_admin_app/screens/event/add_event/widgets/add_event_address.dart';
import 'package:sanskar_pg_admin_app/screens/event/add_event/widgets/event_info.dart';
import 'package:sanskar_pg_admin_app/screens/event/add_event/widgets/event_timing.dart';
import 'package:sanskar_pg_admin_app/screens/event/add_event/widgets/upload_event_image.dart';
import 'package:sanskar_pg_admin_app/utils/theme/color_palette.dart';
import 'package:sanskar_pg_admin_app/widgets/button/rounded_border_button.dart';

class AddEvent extends StatelessWidget {
  final Event? event;

  const AddEvent({Key? key, this.event}) : super(key: key);

  List<Step> getSteps(int currentStep) {
    return [
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          content: const EventInformation(),
          title: Container()),
      Step(
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          content: const EventTiming(),
          title: Container()),
      Step(
          isActive: currentStep >= 2,
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          content: const AddAddress(),
          title: Container()),
      Step(
          isActive: currentStep >= 3,
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          content: const UploadEventImage(),
          title: Container()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    AddEventController addEventController = Get.put(AddEventController());
    if (event != null) {
      addEventController.event = event;
    }
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
          event == null ? 'Add Event' : 'Update Event',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorPalette.red,
            ),
            canvasColor: Colors.white),
        child: GetBuilder<AddEventController>(builder: (addEventController) {
          int currentStep = addEventController.currentStep;
          return Stepper(
            elevation: 0,
            type: StepperType.horizontal,
            steps: getSteps(currentStep),
            currentStep: currentStep,
            onStepTapped: (index) {
              if (index < currentStep || addEventController.validateData()) {
                addEventController.currentStep = index;
              }
            },
            onStepContinue: () {
              bool isLastStep = currentStep == getSteps(currentStep).length - 1;
              if (addEventController.validateData()) {
                if (isLastStep) {
                  addEventController.submitData();
                } else {
                  addEventController.currentStep =
                      addEventController.currentStep + 1;
                }
              }
            },
            controlsBuilder: (context, controlDetails) {
              return Obx(() {
                return Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: RoundedBorderButton(
                      isLoading: addEventController.isLoading.value,
                      onPressed: controlDetails.onStepContinue,
                      buttonText: controlDetails.currentStep ==
                              (getSteps(currentStep).length - 1)
                          ? 'Submit'
                          : 'Next'),
                );
              });
            },
          );
        }),
      ),
    );
  }
}
