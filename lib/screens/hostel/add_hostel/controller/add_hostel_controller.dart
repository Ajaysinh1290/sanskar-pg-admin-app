import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/models/address/address.dart';
import 'package:sanskar_pg_admin_app/models/hostel/hostel.dart';
import 'package:sanskar_pg_admin_app/models/room_rent_history/room_rent_history.dart';
import 'package:sanskar_pg_admin_app/screens/dashboard/dashboard.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/utils/constants/next_month_date.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_error_dialog.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_successful_dialog.dart';

class AddHostelController extends GetxController {
  TextEditingController hostelNameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController cityAddressController = TextEditingController();
  TextEditingController stateAddressController = TextEditingController();
  TextEditingController pinCodeAddressController = TextEditingController();
  TextEditingController acRoomRentController = TextEditingController();
  TextEditingController noneAcRoomRentController = TextEditingController();
  RxBool isLoading = false.obs;
  final List<File> _hostelImages = [];
  List<String> hostelImageUrls = [];
  Hostel? _hostel;

  set hostel(Hostel? hostel) {
    _hostel = hostel;
    if (hostel != null) {
      hostelNameController.text = hostel.hostelName;
      mailController.text = hostel.emailId;
      mobileNumberController.text = hostel.mobileNumber;
      streetAddressController.text = hostel.address.street!;
      cityAddressController.text = hostel.address.city!;
      stateAddressController.text = hostel.address.state!;
      pinCodeAddressController.text = hostel.address.pinCode!;
      noneAcRoomRentController.text =
          hostel.noneAcRoomRentHistory.last.rent.toString();
      acRoomRentController.text = hostel.acRoomRentHistory.last.rent.toString();
      if (hostel.images != null) {
        hostelImageUrls.addAll(hostel.images!.toList());
      }
      update();
    }
  }

  void setHostelImage(File image) {
    _hostelImages.add(image);
    update();
  }

  void removeImage(File image) {
    _hostelImages.remove(image);
    update();
  }

  void removeImageUrl(int index) {
    hostelImageUrls.removeAt(index);
    update();
  }

  List<File> get hostelImages => _hostelImages;
  int _currentStep = 0;

  get currentStep => _currentStep;

  set currentStep(value) {
    _currentStep = value;
    update();
  }

  bool validateData() {
    return _currentStep == 0 && validateHostelInformation() ||
        _currentStep == 1 && validateAddressInformation() ||
        _currentStep == 2 && validateRoomRentInformation();
  }

  bool validateHostelInformation() {
    if (hostelNameController.text.trim().isEmpty) {
      showErrorDialog('Error', 'Hostel Name Can\'t be empty');
      return false;
    } else if (mailController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Mail id can\'t be empty');
      return false;
    } else if (mobileNumberController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Mobile number can\'t be empty');
      return false;
    }
    return true;
  }

  bool validateRoomRentInformation() {
    if (noneAcRoomRentController.text.trim().isEmpty) {
      showErrorDialog('Error', 'None Ac Room Rent Can\'t be mpty');
      return false;
    } else if (acRoomRentController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Ac Room Rent can\'t be empty');
      return false;
    } else {
      try {
        int.parse(noneAcRoomRentController.text.trim());
        int.parse(acRoomRentController.text.trim());
      } on FormatException catch (_) {
        showErrorDialog('Error', 'Only Numbers are allowed');
        return false;
      }
    }
    return true;
  }

  bool validateAddressInformation() {
    if (streetAddressController.text.trim().isEmpty) {
      showErrorDialog('Error', 'Street Address Can\'t be empty');
      return false;
    } else if (cityAddressController.text.trim().isEmpty) {
      showErrorDialog("Error", 'City can\'t be empty');
      return false;
    } else if (stateAddressController.text.trim().isEmpty) {
      showErrorDialog("Error", 'State can\'t be empty');
      return false;
    } else if (pinCodeAddressController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Pin code can\'t be empty');
      return false;
    }
    return true;
  }

  Future<void> submitData() async {
    isLoading.value = true;

    if (_hostel == null) {
      await addHostel();
    } else {
      await updateHostel();
    }

    isLoading.value = false;
  }

  addHostel() async {
    String hostelId = DateTime.now().millisecondsSinceEpoch.toString();
    List<String> imageUrls = await uploadImages(hostelId);
    Hostel hostel = Hostel(
        rooms: [],
        address: Address(
            street: streetAddressController.text.trim(),
            city: cityAddressController.text.trim(),
            state: stateAddressController.text.trim(),
            pinCode: pinCodeAddressController.text.trim()),
        emailId: mailController.text.trim(),
        hostelName: hostelNameController.text.trim(),
        mobileNumber: mobileNumberController.text,
        hostelId: hostelId,
        images: imageUrls,
        acRoomRentHistory: [
          RoomRentHistory(
              rent: int.parse(acRoomRentController.text),
              rentChangingDate: getNextMonthDate())
        ],
        noneAcRoomRentHistory: [
          RoomRentHistory(
              rent: int.parse(noneAcRoomRentController.text),
              rentChangingDate: getNextMonthDate())
        ]);

    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostel.hostelId)
        .set(hostel.toJson());
    await showSuccessfulDialog(
        "Success", 'Hostel has been successfully created.', onTap: () {
      Get.back();
      if (Navigator.canPop(Get.context!)) {
        Get.back();
      } else {
        Get.offAll(Dashboard());
      }
    });
  }

  updateHostel() async {
    List<String> imageUrls = await uploadImages(_hostel!.hostelId);
    hostelImageUrls.addAll(imageUrls.toList());
    _hostel!.images = hostelImageUrls;
    _hostel!.emailId = mailController.text;
    _hostel!.mobileNumber = mobileNumberController.text;
    _hostel!.address.street = streetAddressController.text;
    _hostel!.address.city = cityAddressController.text;
    _hostel!.address.state = stateAddressController.text;
    _hostel!.address.pinCode = pinCodeAddressController.text;
    bool isContains = false;
    for (var element in _hostel!.noneAcRoomRentHistory) {
      if (Constants.onlyDateFormat.format(element.rentChangingDate) ==
          Constants.onlyDateFormat.format(getNextMonthDate())) {
        element.rent = int.parse(noneAcRoomRentController.text);
        isContains = true;
      }
    }
    if (!isContains) {
      _hostel!.noneAcRoomRentHistory.add(RoomRentHistory(
          rent: int.parse(noneAcRoomRentController.text),
          rentChangingDate: getNextMonthDate()));
    }
    isContains = false;
    for (var element in _hostel!.acRoomRentHistory) {
      if (Constants.onlyDateFormat.format(element.rentChangingDate) ==
          Constants.onlyDateFormat.format(getNextMonthDate())) {
        element.rent = int.parse(acRoomRentController.text);
        isContains = true;
      }
    }
    if (!isContains) {
      _hostel!.acRoomRentHistory.add(RoomRentHistory(
          rent: int.parse(acRoomRentController.text),
          rentChangingDate:
              DateTime(DateTime.now().year, DateTime.now().month, 1)));
    }

    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(_hostel!.hostelId)
        .set(_hostel!.toJson());
    await showSuccessfulDialog(
        "Success", 'Hostel has been successfully updated.', onTap: () {
      Get.back();
      if (Navigator.canPop(Get.context!)) {
        Get.back();
      } else {
        Get.offAll(Dashboard());
      }
    });
  }

  Future<List<String>> uploadImages(String hostelId) async {
    List<String> imageUrls = [];
    try {
      for (int i = 0; i < _hostelImages.length; i++) {
        String imageUrlId =
            (DateTime.now().millisecondsSinceEpoch.toString()) + (i.toString());
        await FirebaseStorage.instance
            .ref('hostels/' + hostelId + '/' + imageUrlId + ".jpg")
            .putData(await _hostelImages[i].readAsBytes(),
                SettableMetadata(contentType: 'image/jpeg'))
            .then((storage) async {
          String imageUrl = await storage.ref.getDownloadURL();
          imageUrls.add(imageUrl);
          debugPrint('url : $imageUrl');
        });
      }
    } on FirebaseException catch (_) {
      showErrorDialog("Error", "Error in uploading image to server");
    }
    return imageUrls;
  }
}
