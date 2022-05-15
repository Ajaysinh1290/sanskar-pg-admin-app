import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sanskar_pg_admin_app/models/offer/offer.dart';
import 'package:sanskar_pg_admin_app/screens/offer/add_offer/controller/add_offer_controller.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/date_time_picker/date_picker.dart';
import 'package:sanskar_pg_admin_app/widgets/widgets.dart';

class AddOffer extends StatelessWidget {
  final Offer? offer;

  const AddOffer({Key? key, this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddOfferController addOfferController = Get.put(AddOfferController());
    addOfferController.offer = offer;
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
          offer == null ? 'Add Offer' : 'Edit Offer',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AddOfferController>(builder: (addOfferController) {
        String lastDate = addOfferController.lastDate == null
            ? ''
            : Constants.onlyDateFormat.format(addOfferController.lastDate!);
        return SingleChildScrollView(
          child: Padding(
            padding: Constants.scaffoldPaddingWithoutSafeArea,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offer Information',
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
                  hintText: 'Value',
                  prefixIconData: Icons.local_offer,
                  controller: addOfferController.valueController,
                  isNumber: true,
                ),
                SizedBox(
                  height: 15.h,
                ),
                InkWell(
                  onTap: () async {
                    addOfferController.lastDate = await pickDate(
                        firstDate: addOfferController.lastDate == null
                            ? DateTime.now()
                            : addOfferController.lastDate!,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: addOfferController.lastDate == null
                            ? DateTime.now()
                            : addOfferController.lastDate!);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: AnimatedUnderlineTextField(
                      readOnly: true,
                      hintText: 'Last Date',
                      controller: TextEditingController(text: lastDate),
                      prefixIconData: Icons.date_range,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                MyDropDownMenuButton(
                  value: addOfferController.discountType,
                  onChanged: (value) {
                    addOfferController.discountType = value.toString();
                  },
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        'Select Discount Type',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: '%',
                      child: Text(
                        'Percentage',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: Constants.currencySymbol,
                      child: Text(
                        'Flat',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Obx(
                  () => RoundedBorderButton(
                      onPressed: () {
                        if (addOfferController.validateData()) {
                          addOfferController.submitData();
                        }
                      },
                      isLoading: addOfferController.isLoading.value,
                      buttonText: offer == null ? 'Add Offer' : 'Update Offer'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
