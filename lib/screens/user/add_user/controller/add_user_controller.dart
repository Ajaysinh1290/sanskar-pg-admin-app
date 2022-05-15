import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/controllers/auth_controller.dart';
import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
import 'package:sanskar_pg_admin_app/models/address/address.dart';
import 'package:sanskar_pg_admin_app/models/room/room.dart';
import 'package:sanskar_pg_admin_app/models/room_rent_history/room_rent_history.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/models/user_room_history/user_room_history.dart';
import 'package:sanskar_pg_admin_app/utils/utils.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_error_dialog.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_successful_dialog.dart';

class AddUserController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  DateTime? _dateOfBirth;
  String _gender = '';
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController cityAddressController = TextEditingController();
  TextEditingController stateAddressController = TextEditingController();
  TextEditingController pinCodeAddressController = TextEditingController();
  String _roomId = '';
  UserModel? _userModel;

  RxBool isLoading = false.obs;
  File? _profilePic;
  String? _profilePicUrl;

  final List<String> _documentsUrls = [];
  final List<File> _documents = [];

  set roomId(String value) {
    _roomId = value;
    update();
  }

  set user(UserModel? user) {
    if (user != null) {
      _userModel = user;
      nameController.text = user.userName;
      mailController.text = user.email;
      mobileNumberController.text = user.mobileNumber!;
      dateOfBirth = user.dateOfBirth;
      passwordController.text = user.password;
      gender = user.gender;
      streetAddressController.text = user.address.street!;
      cityAddressController.text = user.address.city!;
      stateAddressController.text = user.address.state!;
      pinCodeAddressController.text = user.address.pinCode!;
      roomId = user.roomHistory.last.roomId;
      profilePicUrl = user.userProfilePic;
      documentsUrls.clear();
      documents.clear();
      for (String imageUrl in user.documents) {
        addDocumentUrl(imageUrl);
      }
      update();
    }
  }

  UserModel? get user => _userModel;

  String get roomId => _roomId;

  set dateOfBirth(DateTime? value) {
    _dateOfBirth = value;
    update();
  }

  DateTime? get dateOfBirth => _dateOfBirth;

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
    update();
  }

  int _currentStep = 0;

  void addDocument(File image) {
    _documents.add(image);
    update();
  }

  void removeImage(int index) {
    _documents.removeAt(index);
    update();
  }

  List<File> get documents => _documents;

  void addDocumentUrl(String imageUrl) {
    _documentsUrls.add(imageUrl);
    update();
  }

  void removeImageUrl(int index) {
    _documentsUrls.removeAt(index);
    update();
  }

  List<String> get documentsUrls => _documentsUrls;

  set profilePic(File? image) {
    _profilePic = image;
    update();
  }

  File? get profilePic => _profilePic;

  set profilePicUrl(String? imageUrl) {
    _profilePicUrl = imageUrl;
    update();
  }

  String? get profilePicUrl => _profilePicUrl;

  set currentStep(int value) {
    _currentStep = value;
    update();
  }

  int get currentStep => _currentStep;

  bool validateData() {
    return _currentStep == 0 && validateAccountInformation() ||
        _currentStep == 1 && validateAddressInformation() ||
        _currentStep == 2 && validateRoomInformation() ||
        _currentStep == 3 && validateDocuments();
  }

  bool validateAccountInformation() {
    if (nameController.text
        .trim()
        .isEmpty) {
      showErrorDialog('Error', 'User name Can\'t be empty');
      return false;
    } else if (mailController.text
        .trim()
        .isEmpty) {
      showErrorDialog("Error", 'Mail id can\'t be empty');
      return false;
    } else if (passwordController.text
        .trim()
        .isEmpty) {
      showErrorDialog("Error", 'Password can\'t be empty');
      return false;
    } else if (mobileNumberController.text
        .trim()
        .isEmpty) {
      showErrorDialog("Error", 'Mobile number id can\'t be empty');
      return false;
    } else if (dateOfBirth == null) {
      showErrorDialog("Error", 'Date of birth can\'t be empty');
      return false;
    } else if (gender
        .trim()
        .isEmpty) {
      showErrorDialog("Error", 'Please select gender');
      return false;
    }
    return true;
  }

  bool validateAddressInformation() {
    if (streetAddressController.text
        .trim()
        .isEmpty) {
      showErrorDialog('Error', 'Street Address Can\'t be empty');
      return false;
    } else if (cityAddressController.text
        .trim()
        .isEmpty) {
      showErrorDialog("Error", 'City can\'t be empty');
      return false;
    } else if (stateAddressController.text
        .trim()
        .isEmpty) {
      showErrorDialog("Error", 'State can\'t be empty');
      return false;
    } else if (pinCodeAddressController.text
        .trim()
        .isEmpty) {
      showErrorDialog("Error", 'Pin code can\'t be empty');
      return false;
    }
    return true;
  }

  bool validateRoomInformation() {
    if (roomId
        .trim()
        .isEmpty) {
      showErrorDialog("Error", 'Please select room');
      return false;
    }
    return true;
  }

  bool validateDocuments() {
    if (profilePic == null && profilePicUrl == null) {
      showErrorDialog("Error", 'Please select profile pic');
      return false;
    } else if (documents.isEmpty && documentsUrls.isEmpty) {
      showErrorDialog("Error", 'Please add any ID Proof');
      return false;
    }
    return true;
  }

  Future<void> assignRoom(String hostelId, String userId) async {
    Room? room;
    debugPrint('assigning room started');
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostelId)
        .collection('rooms')
        .doc(roomId)
        .get()
        .then((value) async {
      room = Room.fromJson(value.data()!);
      debugPrint(room!.toJson().toString());

      if (room!.users == null) {
        room!.users = [];
      }
      if (!(room!.users!.contains(userId))) {
        room!.users!.add(userId);
        await FirebaseFirestore.instance
            .collection('hostels')
            .doc(hostelId)
            .collection('rooms')
            .doc(roomId)
            .set(room!.toJson());
        debugPrint('new room assigned');
      }
    });
  }

  Future<void> deleteOldRoom(String hostelId, String userId) async {
    Room? room;
    debugPrint('room deleting started');
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostelId)
        .collection('rooms')
        .doc(_userModel!.roomHistory.last.roomId)
        .get()
        .then((value) async {
      room = Room.fromJson(value.data()!);
      debugPrint(room!.toJson().toString());
      room!.users ??= [];
      if ((room!.users!.contains(userId))) {
        room!.users!.remove(userId);
        await FirebaseFirestore.instance
            .collection('hostels')
            .doc(hostelId)
            .collection('rooms')
            .doc(_userModel!.roomHistory.last.roomId)
            .set(room!.toJson());
        debugPrint('old room deleted');
      }
    });
  }

  Future<String> uploadProfilePic(String userId) async {
    String profilePicUrl = '';
    try {
      await FirebaseStorage.instance
          .ref('users/' + userId + '/' + 'profile_pic' + ".jpg")
          .putData(await _profilePic!.readAsBytes(),
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

  Future<List<String>> uploadDocuments(String userId) async {
    List<String> imageUrls = [];
    try {
      for (int i = 0; i < documents.length; i++) {
        String imageUrlId =
            (DateTime
                .now()
                .millisecondsSinceEpoch
                .toString()) + (i.toString());
        await FirebaseStorage.instance
            .ref('users/' + userId + '/' + imageUrlId + ".jpg")
            .putData(await documents[i].readAsBytes(),
            SettableMetadata(contentType: 'image/jpeg'))
            .then((storage) async {
          String imageUrl = await storage.ref.getDownloadURL();
          imageUrls.add(imageUrl);
          debugPrint('url : $imageUrl');
        });
      }
    } on FirebaseException catch (_) {
      showErrorDialog("Error", "Error in uploading image to server");
    } catch (e) {
      showErrorDialog(
          "Error", "Error in uploading image to server\n${e.toString()}");
    }
    return imageUrls;
  }

  submitData() async {
    isLoading.value = true;

    if (_userModel == null) {
      await addUser();
    } else {
      await updateUser();
    }
    isLoading.value = false;
  }

  Future<void> addUser() async {
    AuthController authController = Get.find();
    HostelController hostelController = Get.find();

    UserCredential? userCredential = await authController.registerUser(
        mailController.text.trim(), passwordController.text);
    if (userCredential != null && userCredential.user != null) {
      String profilePicUrl = await uploadProfilePic(userCredential.user!.uid);
      List<String> documentsUrl =
      await uploadDocuments(userCredential.user!.uid);

      debugPrint('profile pic url : $profilePicUrl');
      debugPrint('documents : $documentsUrl');

      _userModel = UserModel(
          hostelId: hostelController.hostel!.hostelId,
          userId: userCredential.user!.uid,
          password: passwordController.text,
          dateOfBirth: dateOfBirth!,
          roomHistory: [
            UserRoomHistory(
                roomId: roomId,
                roomChangingDate: Constants.onlyDateFormat
                    .parse(Constants.onlyDateFormat.format(DateTime.now())))
          ],
          userProfilePic: profilePicUrl,
          address: Address(
              street: streetAddressController.text.trim(),
              city: cityAddressController.text.trim(),
              state: stateAddressController.text.trim(),
              pinCode: pinCodeAddressController.text.trim()),
          mobileNumber: mobileNumberController.text.trim(),
          gender: gender,
          admissionDate: DateTime.now(),
          userName: nameController.text.trim(),
          email: mailController.text.trim(),
          documents: documentsUrl,
          points: 0,
          isAccountApproved: true,
          isAccountRejected: false,
          isAccountBlocked: false);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(_userModel!.toJson());
      await assignRoom(hostelController.hostel!.hostelId, _userModel!.userId);
      debugPrint('Account created');
      showSuccessfulDialog(
          "Account Created", 'User account has been added successfully.',
          onTap: () {
            Get.back();
            Get.back();
          });
    }
  }

  Future<void> updateUser() async {
    if (_userModel!.email != mailController.text.trim()) {
      AuthController authController = Get.find();
      bool result = await authController.changeEmail(
          _userModel!.email, _userModel!.password, mailController.text);
      if (!result) return;
    }
    if (_userModel!.roomHistory.last.roomId != roomId) {
      HostelController hostelController = Get.find();
      await deleteOldRoom(
          hostelController.hostel!.hostelId, _userModel!.userId);
      await assignRoom(hostelController.hostel!.hostelId, _userModel!.userId);
      bool isContains = false;
      for (var element in _userModel!.roomHistory) {
        if (Constants.onlyDateFormat.format(element.roomChangingDate) ==
            Constants.onlyDateFormat.format(Constants.onlyDateFormat
                .parse(Constants.onlyDateFormat.format(DateTime.now())))) {
          element.roomId = roomId;
          isContains = true;
        }
      }
      if (!isContains) {
        _userModel!.roomHistory.add(UserRoomHistory(roomId: roomId,
            roomChangingDate: Constants.onlyDateFormat.parse(Constants.onlyDateFormat.format(DateTime.now()))));
      }
      _userModel!.roomHistory.add(UserRoomHistory(
          roomId: roomId,
          roomChangingDate: Constants.onlyDateFormat
              .parse(Constants.onlyDateFormat.format(DateTime.now()))));
    }
    _documentsUrls.addAll(await uploadDocuments(_userModel!.userId));

    _userModel!.email = mailController.text.trim();
    _userModel!.userName = nameController.text.trim();
    _userModel!.mobileNumber = mobileNumberController.text.trim();
    _userModel!.dateOfBirth = _dateOfBirth!;
    _userModel!.gender = gender;
    _userModel!.address.street = streetAddressController.text.trim();
    _userModel!.address.city = cityAddressController.text.trim();
    _userModel!.address.state = stateAddressController.text.trim();
    _userModel!.address.pinCode = pinCodeAddressController.text.trim();
    _userModel!.userProfilePic = profilePic != null
        ? await uploadProfilePic(_userModel!.userId)
        : _userModel!.userProfilePic!;
    _userModel!.documents = _documentsUrls;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userModel!.userId)
        .set(_userModel!.toJson());
    debugPrint('Account created');

    showSuccessfulDialog(
        "Account Updated", 'User account has been updated successfully.',
        onTap: () {
          Get.back();
          Get.back();
        });
  }
}
