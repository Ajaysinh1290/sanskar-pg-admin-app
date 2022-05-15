import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/food/food.dart';
import 'dart:io';

import 'package:sanskar_pg_admin_app/widgets/dialog/show_error_dialog.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_successful_dialog.dart';

class AddFoodController extends GetxController {
  TextEditingController foodNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? _image;
  bool _isAvailable = true;
  String? _imageUrl;
  bool _isImageUploadedOnStorage = false;

  set isAvailable(value) {
    _isAvailable = value;
    update();
  }

  get isAvailable => _isAvailable;

  set image(File? image) {
    _image = image;
    update();
  }

  set imageUrl(String? imageUrl) {
    if (imageUrl != null) {
      _isImageUploadedOnStorage = true;
    }
    _imageUrl = imageUrl;
    update();
  }

  File? get image => _image;

  String? get imageUrl => _imageUrl;

  RxBool isLoading = false.obs;

  bool validateData() {
    if (foodNameController.text.trim().isEmpty) {
      showErrorDialog('Error', 'Food name can\'t be empty');
      return false;
    } else if (priceController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Price can\'t be empty');
      return false;
    }
    return true;
  }

  Future<void> submitData({String? oldFoodId}) async {
    isLoading.value = true;
    debugPrint('food id : $oldFoodId');
    HostelController hostelController = Get.find();
    String foodId =
        oldFoodId ?? DateTime.now().millisecondsSinceEpoch.toString();
    String? foodImage = image != null ? await uploadImage(foodId) : imageUrl;
    if (_isImageUploadedOnStorage) {
      await removeImageFromStorage(foodId);
    }
    Food food = Food(
        foodId: foodId,
        foodImage: foodImage,
        foodName: foodNameController.text.trim(),
        price: num.parse(priceController.text.trim()),
        description: descriptionController.text.trim(),
        hostels: [hostelController.hostel!.hostelId],
        isAvailable: isAvailable);
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(Get.find<HostelController>().hostel?.hostelId)
        .collection('foods')
        .doc(food.foodId)
        .set(food.toJson());
    showSuccessfulDialog('Food ${oldFoodId == null ? 'Added' : 'Updated'}',
        'Food has been ${oldFoodId == null ? 'added' : 'updated'} successfully',
        onTap: () {
      Get.back();
      Get.back();
    });
    isLoading.value = false;
  }

  Future<void> removeImageFromStorage(String foodId) async {
    await FirebaseStorage.instance.ref('foods/' + foodId + ".jpg").delete();
  }

  Future<String> uploadImage(String foodId) async {
    String profilePicUrl = '';
    try {
      await FirebaseStorage.instance
          .ref('foods/' + foodId + ".jpg")
          .putData(await image!.readAsBytes(),
              SettableMetadata(contentType: 'image/jpeg'))
          .then((storage) async {
        profilePicUrl = await storage.ref.getDownloadURL();
      });
    } on FirebaseException catch (_) {
      showErrorDialog("Error", "Error in uploading image to server");
    } catch (e) {
      showErrorDialog(
          "Error", "Error in uploading image to server\n${e.toString()}");
    }
    return profilePicUrl;
  }
}
