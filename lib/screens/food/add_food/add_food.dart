import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/animation/fade_and_translate_animation.dart';
import 'package:sanskar_pg_admin_app/models/food/food.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/button/rounded_border_button.dart';
import 'package:sanskar_pg_admin_app/widgets/image/image_network.dart';
import 'package:sanskar_pg_admin_app/widgets/image/pick_image.dart';
import 'package:sanskar_pg_admin_app/widgets/text-field/text_field.dart';

import 'controller/add_food_controller.dart';

class AddFood extends StatelessWidget {
  final Food? food;

  const AddFood({Key? key, this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddFoodController addFoodController = Get.put(AddFoodController());
    if (food != null) {
      addFoodController.foodNameController.text = food!.foodName;
      addFoodController.priceController.text = food!.price.toString();
      addFoodController.descriptionController.text = food!.description ?? '';
      addFoodController.isAvailable = food!.isAvailable;
      addFoodController.imageUrl = food!.foodImage;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 30.sp,
              color: Colors.black,
            )),
        title: Text(
          food == null ? 'Add Food' : 'Edit Food',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AddFoodController>(builder: (addFoodController) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: Constants.scaffoldPaddingWithoutSafeArea,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeAnimationTranslateY(
                  delay: 1.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: addFoodController.image == null &&
                            addFoodController.imageUrl == null
                        ? InkWell(
                            onTap: () async {
                              File? pickedFile = await pickImage();
                              if (pickedFile != null) {
                                addFoodController.image = pickedFile;
                              }
                            },
                            child: Container(
                              width: 175.w,
                              height: 175.w,
                              color: Theme.of(context).cardColor,
                              child: Icon(
                                Icons.fastfood,
                                size: 30.sp,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              addFoodController.image != null
                                  ? Image.file(
                                      addFoodController.image!,
                                      width: 175.w,
                                      height: 175.w,
                                      fit: BoxFit.cover,
                                    )
                                  : ImageNetwork(
                                      imageUrl: addFoodController.imageUrl!,
                                      width: 175.w,
                                      height: 175.w,
                                      fit: BoxFit.cover,
                                    ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  width: 100.w,
                                  height: 100.w,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: 30.sp,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      addFoodController.imageUrl = null;
                                      addFoodController.image = null;
                                    },
                                  ),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.black38,
                                          Colors.transparent
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.center),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(35)),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 15.w,
                ),
                FadeAnimationTranslateY(
                  delay: 1.2,
                  child: InkWell(
                    onTap: () async {
                      File? pickedFile = await pickImage();
                      if (pickedFile != null) {
                        addFoodController.image = pickedFile;
                      }
                    },
                    child: Text(
                      addFoodController.image == null &&
                              addFoodController.imageUrl == null
                          ? 'ADD PHOTO'
                          : 'EDIT PHOTO',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(letterSpacing: 2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                FadeAnimationTranslateY(
                    delay: 1.4,
                    child: Text(
                      '(optional)',
                      style: Theme.of(context).textTheme.subtitle2,
                    )),
                SizedBox(
                  height: 30.h,
                ),
                FadeAnimationTranslateY(
                  delay: 1.6,
                  child: AnimatedUnderlineTextField(
                    hintText: 'Food Name',
                    prefixIconData: Icons.fastfood,
                    controller: addFoodController.foodNameController,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                FadeAnimationTranslateY(
                  delay: 1.8,
                  child: AnimatedUnderlineTextField(
                    hintText: 'Price',
                    prefixIconData: Icons.credit_card,
                    isNumber: true,
                    suffixText: Constants.currencySymbol,
                    controller: addFoodController.priceController,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                FadeAnimationTranslateY(
                  delay: 2.0,
                  child: AnimatedUnderlineTextField(
                    hintText: 'Description (optional)',
                    expanded: true,
                    keyboardType: TextInputType.multiline,
                    prefixIconData: Icons.description,
                    controller: addFoodController.descriptionController,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                FadeAnimationTranslateY(
                  delay: 2.2,
                  child: Row(
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
                          value: addFoodController.isAvailable,
                          onChanged: (value) {
                            addFoodController.isAvailable = value;
                          })
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                FadeAnimationTranslateY(
                  delay: 2.4,
                  child: Obx(
                    () => RoundedBorderButton(
                      isLoading: addFoodController.isLoading.value,
                      onPressed: () {
                        if (addFoodController.validateData()) {
                          addFoodController.submitData(oldFoodId: food?.foodId);
                        }
                      },
                      buttonText: 'Add Food',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
