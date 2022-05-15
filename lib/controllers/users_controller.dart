// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
// import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
//
// class UsersController extends GetxController {
//   final Rx<List<UserModel>?> _users = Rxn<List<UserModel>>();
//
//   List<UserModel>? get users => _users.value;
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     _users.bindStream(_usersStream());
//   }
//
//   Stream<List<UserModel>> _usersStream() {
//     return FirebaseFirestore.instance
//         .collection('users')
//         .where('hostelId',
//             isEqualTo: Get.find<HostelController>().hostel!.hostelId)
//         .where('isAccountApproved', isEqualTo: true)
//         .where('isAccountRejected', isEqualTo: false)
//         .snapshots()
//         .map((event) {
//       List<UserModel> usersList = [];
//       for (var element in event.docs) {
//         usersList.add(UserModel.fromJson(element.data()));
//       }
//       debugPrint('users list $usersList');
//       return usersList;
//     });
//   }
// }
