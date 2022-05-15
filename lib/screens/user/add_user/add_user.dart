import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/screens/user/add_user/widgets/account_information.dart';
import 'package:sanskar_pg_admin_app/screens/user/add_user/widgets/add_user_address.dart';
import 'package:sanskar_pg_admin_app/screens/user/add_user/widgets/select_room.dart';
import 'package:sanskar_pg_admin_app/screens/user/add_user/widgets/upload_documents.dart';
import 'package:sanskar_pg_admin_app/utils/theme/color_palette.dart';
import 'package:sanskar_pg_admin_app/widgets/button/rounded_border_button.dart';

import 'controller/add_user_controller.dart';

class AddUser extends StatelessWidget {
  final UserModel? user;

  const AddUser({Key? key, this.user}) : super(key: key);

  List<Step> getSteps(int currentStep) {
    return [
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          content: const AccountInformation(),
          title: Container()),
      Step(
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          content: const AddUserAddress(),
          title: Container()),
      Step(
          isActive: currentStep >= 2,
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          content: const SelectRoom(),
          title: Container()),
      Step(
          isActive: currentStep >= 3,
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          content: const UploadDocuments(),
          title: Container()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    AddUserController addUserController = Get.put(AddUserController());
    if (user != null) {
      addUserController.user = user!;
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
          user==null?'Add User':'Edit User',
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
        child: GetBuilder<AddUserController>(builder: (addUserController) {
          int currentStep = addUserController.currentStep;
          return Stepper(
            elevation: 0,
            type: StepperType.horizontal,
            steps: getSteps(currentStep),
            currentStep: currentStep,
            onStepTapped: (index) {
              if (index < currentStep || addUserController.validateData()) {
                addUserController.currentStep = index;
              }
            },
            onStepContinue: () {
              bool isLastStep = currentStep == getSteps(currentStep).length - 1;
              if (addUserController.validateData()) {
                if (isLastStep) {
                  debugPrint(addUserController.nameController.text);
                  debugPrint(addUserController.mailController.text);
                  debugPrint(addUserController.mobileNumberController.text);
                  debugPrint(addUserController.dateOfBirth.toString());
                  debugPrint(addUserController.gender);
                  debugPrint(addUserController.stateAddressController.text);
                  debugPrint(addUserController.cityAddressController.text);
                  debugPrint(addUserController.stateAddressController.text);
                  debugPrint(addUserController.pinCodeAddressController.text);
                  debugPrint(addUserController.roomId);
                  addUserController.submitData();
                  debugPrint('completed');
                } else {
                  addUserController.currentStep =
                      addUserController.currentStep + 1;
                }
              }
            },
            controlsBuilder: (context, controlDetails) {
              return Obx(() {
                return Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: RoundedBorderButton(
                      isLoading: addUserController.isLoading.value,
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
