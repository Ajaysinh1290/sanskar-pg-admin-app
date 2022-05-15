import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/offer/offer.dart';
import 'package:sanskar_pg_admin_app/models/room/room.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_error_dialog.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_successful_dialog.dart';

class AddOfferController extends GetxController {
  TextEditingController valueController = TextEditingController();
  DateTime? _lastDate;

  DateTime? get lastDate => _lastDate;
  String _discountType = '';

  String get discountType => _discountType;
  String? _offerId;

  set discountType(String value) {
    _discountType = value;
    update();
  }

  set lastDate(DateTime? value) {
    _lastDate = value;
    update();
  }

  bool _isDeleted = false;

  bool get isDeleted => _isDeleted;

  set isDeleted(bool value) {
    _isDeleted = value;
    update();
  }

  set offer(Offer? offer) {
    if (offer != null) {
      _offerId = offer.offerId;
      valueController.text = offer.value.toString();
      lastDate = offer.lastDate;
    }
    update();
  }

  RxBool isLoading = false.obs;

  bool validateData() {
    if (valueController.text.trim().isEmpty) {
      showErrorDialog('Error', 'Value Can\'t be empty');
      return false;
    } else if (lastDate == null) {
      showErrorDialog("Error", 'Last Date can\'t be empty');
      return false;
    } else if (discountType.trim().isEmpty) {
      showErrorDialog("Error", 'Select Discount Type');
      return false;
    }
    return true;
  }

  Future<void> submitData() async {
    isLoading.value = true;

    Offer offer = Offer(
        value: num.parse(valueController.text.trim()),
        lastDate: lastDate!,
        discountType: discountType,
        offerId: DateTime.now().millisecondsSinceEpoch.toString());

    HostelController hostelController = Get.find();
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostelController.hostel!.hostelId)
        .collection('offers')
        .doc(offer.offerId)
        .set(offer.toJson());
    showSuccessfulDialog('Offer ${_offerId == null ? 'Added' : 'Updated'}',
        'Offer has been ${_offerId == null ? 'added' : 'updated'} successfully',
        onTap: () {
      Get.back();
      Get.back();
    });
    isLoading.value = false;
  }

}
