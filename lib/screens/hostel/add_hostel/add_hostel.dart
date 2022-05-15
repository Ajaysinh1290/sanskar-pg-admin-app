import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/hostel/hostel.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/controller/add_hostel_controller.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/widgets/add_hostel_address.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/widgets/hostel_images.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/widgets/hostel_information.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/widgets/room_rent_information.dart';
import 'package:sanskar_pg_admin_app/utils/theme/color_palette.dart';
import 'package:sanskar_pg_admin_app/widgets/button/rounded_border_button.dart';

class AddHostel extends StatelessWidget {
  final Hostel? hostel;

  const AddHostel({Key? key, this.hostel}) : super(key: key);

  List<Step> getSteps(int currentStep) {
    return [
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          content: const HostelInformation(),
          title: Container()),
      Step(
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          content: const AddHostelAddress(),
          title: Container()),
      Step(
          isActive: currentStep >= 2,
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          content: const RoomRentInformation(),
          title: Container()),
      Step(
          isActive: currentStep >= 3,
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          content: const HostelImages(),
          title: Container()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    AddHostelController addHostelController = Get.put(AddHostelController());
    if (hostel != null) {
      addHostelController.hostel = hostel;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.black,
                ))
            : null,
        elevation: 0,
        title: Text(
          hostel != null ? 'Edit Hostel' : 'Add Hostel',
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
        child: GetBuilder<AddHostelController>(builder: (addHostelController) {
          int currentStep = addHostelController.currentStep;
          return Stepper(
            elevation: 0,
            type: StepperType.horizontal,
            steps: getSteps(currentStep),
            currentStep: currentStep,
            onStepTapped: (index) {
              if (index < currentStep || addHostelController.validateData()) {
                addHostelController.currentStep = index;
              }
            },
            onStepContinue: () async {
              bool isLastStep = currentStep == getSteps(currentStep).length - 1;
              if (isLastStep) {
                debugPrint(addHostelController.hostelNameController.text);
                debugPrint(addHostelController.mailController.text);
                debugPrint(addHostelController.mobileNumberController.text);
                debugPrint(addHostelController.streetAddressController.text);
                debugPrint(addHostelController.cityAddressController.text);
                debugPrint(addHostelController.stateAddressController.text);
                debugPrint(addHostelController.pinCodeAddressController.text);
                for (File image in addHostelController.hostelImages) {
                  debugPrint(image.path);
                }
                await addHostelController.submitData();
                debugPrint('completed');
              } else {
                if (addHostelController.validateData()) {
                  addHostelController.currentStep =
                      addHostelController.currentStep + 1;
                }
              }
            },
            controlsBuilder: (context, controlDetails) {
              return Obx(() {
                return Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: RoundedBorderButton(
                      isLoading: addHostelController.isLoading.value,
                      onPressed: controlDetails.onStepContinue,
                      buttonText: controlDetails.currentStep == 3
                          ? hostel == null
                              ? 'Submit'
                              : 'Update'
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
