import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/address/address.dart';
import 'package:sanskar_pg_admin_app/models/event/event.dart';
import 'package:sanskar_pg_admin_app/services/notification_service.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_error_dialog.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_successful_dialog.dart';

class AddEventController extends GetxController {
  RxBool isLoading = false.obs;
  int _currentStep = 0;
  TextEditingController eventTitleController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  DateTime? _startingDate;
  DateTime? _endingDate;
  DateTime? _startingTime;
  DateTime? _endingTime;
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController cityAddressController = TextEditingController();
  TextEditingController stateAddressController = TextEditingController();
  TextEditingController pinCodeAddressController = TextEditingController();
  File? _eventImage;
  String? _eventImageUrl;
  Event? _event;

  set event(Event? event) {
    if (event != null) {
      _event = event;
      eventTitleController.text = event.eventTitle;
      eventDescriptionController.text = event.description ?? '';
      startingDate = event.startingDate;
      endingDate = event.endingDate;
      startingTime = event.startingTime;
      endingTime = event.endingTime;
      streetAddressController.text = event.address.street ?? '';
      cityAddressController.text = event.address.city ?? '';
      stateAddressController.text = event.address.state ?? '';
      pinCodeAddressController.text = event.address.pinCode ?? '';
      eventImageUrl = event.eventImage;
    }
  }

  Event? get event => _event;

  set eventImageUrl(String? imageUrl) {
    _eventImageUrl = imageUrl;
    update();
  }

  String? get eventImageUrl => _eventImageUrl;

  set startingDate(DateTime? dateTime) {
    _startingDate = dateTime;
    update();
  }

  DateTime? get startingDate => _startingDate;

  set endingDate(DateTime? dateTime) {
    _endingDate = dateTime;
    update();
  }

  DateTime? get endingDate => _endingDate;

  set startingTime(DateTime? dateTime) {
    _startingTime = dateTime;
    update();
  }

  DateTime? get startingTime => _startingTime;

  set endingTime(DateTime? dateTime) {
    _endingTime = dateTime;
    update();
  }

  DateTime? get endingTime => _endingTime;

  set currentStep(int value) {
    _currentStep = value;
    update();
  }

  int get currentStep => _currentStep;

  set eventImage(File? image) {
    _eventImage = image;
    update();
  }

  File? get eventImage => _eventImage;

  bool validateData() {
    return _currentStep == 0 && validateEventInformation() ||
        _currentStep == 1 && validateEventTiming() ||
        _currentStep == 2 && validateAddressInformation() ||
        _currentStep == 3 && validateEventImage();
  }

  bool validateEventInformation() {
    if (eventTitleController.text.trim().isEmpty) {
      showErrorDialog('Error', 'Event Title Can\'t be empty');
      return false;
    } else if (eventDescriptionController.text.trim().isEmpty) {
      showErrorDialog("Error", 'Event Description can\'t be empty');
      return false;
    }
    return true;
  }

  bool validateEventTiming() {
    if (startingDate == null) {
      showErrorDialog('Error', 'Starting Date Can\'t be empty');
      return false;
    } else if (endingDate == null) {
      showErrorDialog("Error", 'Ending Date can\'t be empty');
      return false;
    } else if (startingTime == null) {
      showErrorDialog("Error", 'Starting Time can\'t be empty');
      return false;
    } else if (endingTime == null) {
      showErrorDialog("Error", 'Ending Time can\'t be empty');
      return false;
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

  bool validateEventImage() {
    if (eventImage == null && eventImageUrl == null) {
      showErrorDialog('Error', 'Event Image Can\'t be empty');
      return false;
    }
    return true;
  }

  Future<void> submitData() async {
    isLoading.value = true;

    if (event == null) {
      await addEvent();
    } else {
      await updateEvent();
    }
    isLoading.value = false;
  }

  updateEvent() async {
    if (eventImage != null) {
      event!.eventImage = await uploadEventImage(event!.eventId);
    }
    event!.eventTitle = eventTitleController.text;
    event!.description = eventDescriptionController.text;
    event!.address.street = streetAddressController.text;
    event!.startingDate = startingDate!;
    event!.endingDate = endingDate!;
    event!.startingTime = startingTime!;
    event!.endingTime = endingTime!;
    event!.address.city = cityAddressController.text;
    event!.address.state = stateAddressController.text;
    event!.address.pinCode = pinCodeAddressController.text;
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(event!.hostelId)
        .collection('events')
        .doc(event!.eventId)
        .set(event!.toJson());
    await NotificationService.sendNotification(
        'Event Updated - ' + event!.eventTitle,
        event!.description ?? '',
        {'screen': 'event', 'event_id': event!.eventId},
        event!.hostelId,
        imageUrl: event!.eventImage);
    await showSuccessfulDialog(
        "Success", 'Event has been updated successfully.', onTap: () {
      Get.back();
      Get.back();
    });
  }

  addEvent() async {
    String eventId = DateTime.now().millisecondsSinceEpoch.toString();
    String imageUrl = await uploadEventImage(eventId);

    Event event = Event(
        eventTitle: eventTitleController.text.trim(),
        endingTime: endingTime!,
        address: Address(
            street: streetAddressController.text.trim(),
            city: cityAddressController.text.trim(),
            state: stateAddressController.text.trim(),
            pinCode: pinCodeAddressController.text.trim()),
        endingDate: endingDate!,
        eventId: eventId,
        description: eventDescriptionController.text.trim(),
        startingTime: startingTime!,
        eventImage: imageUrl,
        startingDate: startingDate!,
        hostelId: Get.find<HostelController>().hostel!.hostelId);

    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(event.hostelId)
        .collection('events')
        .doc(event.eventId)
        .set(event.toJson());
    await NotificationService.sendNotification(
        'New Event - ' + event.eventTitle,
        event.description ?? '',
        {'screen': 'event', 'event_id': event.eventId},
        event.hostelId,
        imageUrl: imageUrl);
    await showSuccessfulDialog(
        "Success", 'Event has been created successfully.', onTap: () {
      Get.back();
      Get.back();
    });
  }

  Future<String> uploadEventImage(String eventId) async {
    String eventImageUrl = '';
    try {
      await FirebaseStorage.instance
          .ref('events/' + eventId + ".jpg")
          .putData(await eventImage!.readAsBytes(),
              SettableMetadata(contentType: 'image/jpeg'))
          .then((storage) async {
        eventImageUrl = await storage.ref.getDownloadURL();
      });
    } on FirebaseException catch (_) {
      showErrorDialog("Error", "Error in uploading image to server");
    } catch (e) {
      showErrorDialog(
          "Error", "Error in uploading image to server\n${e.toString()}");
    }
    return eventImageUrl;
  }
}
