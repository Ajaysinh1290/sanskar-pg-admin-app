// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:sanskar_pg_admin_app/controllers/hostel_controller.dart';
// import 'package:sanskar_pg_admin_app/models/room/room.dart';
// import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
//
// class RoomsController extends GetxController {
//   final Rx<List<Room>?> _rooms = Rxn<List<Room>>();
//
//   List<Room>? get rooms => _rooms.value;
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     _rooms.bindStream(_roomsStream());
//   }
//
//   Stream<List<Room>> _roomsStream() {
//     return FirebaseFirestore.instance
//         .collection('hostels')
//         .doc(Get.find<HostelController>().hostel!.hostelId)
//         .collection('rooms')
//         .snapshots()
//         .map((event) {
//       List<Room> roomsList = [];
//       for (var element in event.docs) {
//         roomsList.add(Room.fromJson(element.data()));
//       }
//       roomsList.sort((a, b) => '${a.wing}-${a.floor}-${a.roomNumber}'
//           .compareTo('${b.wing}-${b.floor}-${b.roomNumber}'));
//       return roomsList;
//     });
//   }
// }
