import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/room/room.dart';
import 'package:sanskar_pg_admin_app/utils/constants/constants.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_error_dialog.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_successful_dialog.dart';

class AddRoomController extends GetxController {
  TextEditingController wingController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController roomRentController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  bool _isActive = true;
  String _roomType = '';
  String? _roomId;

  set isActive(value) {
    _isActive = value;
    update();
  }

  get isActive => _isActive;

  set roomType(value) {
    _roomType = value;
    update();
  }

  set room(Room? room) {
    if (room != null) {
      wingController.text = room.wing;
      floorController.text = room.floor.toString();
      roomNumberController.text = room.roomNumber.toString();
      capacityController.text = room.capacity.toString();
      roomType = room.roomType;
      isActive = room.isActive;
      _roomId = room.roomId;
    }
    update();
  }

  get roomType => _roomType;

  RxBool isLoading = false.obs;

  bool validateData() {
    if (wingController.text.trim().isEmpty) {
      showErrorDialog('Error', 'Wing name Can\'t be empty');
      return false;
    } else if (floorController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Floor can\'t be empty');
      return false;
    } else if (roomNumberController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Room number can\'t be empty');
      return false;
    } else if (capacityController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Capacity can\'t be empty');
      return false;
    } else if (_roomType.isEmpty) {
      showErrorDialog("Error", 'Select room type');
      return false;
    }
    return true;
  }

  Future<void> submitData() async {
    isLoading.value = true;

    Room room = Room(
        wing: wingController.text,
        capacity: int.parse(capacityController.text.trim()),
        roomNumber: int.parse(roomNumberController.text.trim()),
        roomId: _roomId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        isActive: isActive,
        floor: int.parse(floorController.text.trim()),
        roomType: _roomType);

    HostelController hostelController = Get.find();
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostelController.hostel!.hostelId)
        .collection('rooms')
        .doc(room.roomId)
        .set(room.toJson());
    showSuccessfulDialog('Room ${_roomId == null ? 'Added' : 'Updated'}',
        'Room has been ${_roomId == null ? 'added' : 'updated'} successfully', onTap: () {
      Get.back();
      Get.back();
    });
    isLoading.value = false;
  }

  updateRoom() {}
}
