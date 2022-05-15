import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sanskar_pg_admin_app/models/hostel/hostel.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/screens/dashboard/dashboard.dart';
import 'package:sanskar_pg_admin_app/screens/hostel/add_hostel/add_hostel.dart';

class HostelController extends GetxController {
  final Rx<List<Hostel>> _hostels = Rx<List<Hostel>>([]);

  List<Hostel> get hostels => _hostels.value;
  final RxInt _currentHostel = 0.obs;

  set currentHostel(hostelIndex) {
    _currentHostel.value = hostelIndex;
    update();
  }

  get currentHostel => _currentHostel.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _hostels.bindStream(_hostelStream());
    ever(_hostels, _setUpHostel);
  }

  void _setUpHostel(List<Hostel> hostels) {
    if (hostels.isEmpty) {
      Get.offAll(const AddHostel());
    }
  }

  Hostel? get hostel {
    if (hostels.isNotEmpty) {
      return hostels[currentHostel];
    }
  }

  deleteHostel() async {
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostel!.hostelId)
        .collection('rooms')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        await FirebaseFirestore.instance
            .collection('hostels')
            .doc(hostel!.hostelId)
            .collection('rooms')
            .doc(element.data()['roomId'])
            .delete();
      }
    });
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostel!.hostelId)
        .collection('transactions')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        await FirebaseFirestore.instance
            .collection('hostels')
            .doc(hostel!.hostelId)
            .collection('transactions')
            .doc(element.data()['transactionId'])
            .delete();
      }
    });
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostel!.hostelId)
        .collection('chat')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        await FirebaseFirestore.instance
            .collection('hostels')
            .doc(hostel!.hostelId)
            .collection('chat')
            .doc(element.data()['chatId'])
            .delete();
      }
    });
    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostel!.hostelId)
        .collection('events')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        await FirebaseFirestore.instance
            .collection('hostels')
            .doc(hostel!.hostelId)
            .collection('events')
            .doc(element.data()['eventId'])
            .delete();
      }
    });

    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(hostel!.hostelId)
        .delete();
    FirebaseMessaging.instance.unsubscribeFromTopic(hostel!.hostelId);

    currentHostel = 0;
    Get.offAll(Dashboard());
  }

  Stream<List<Hostel>> _hostelStream() {
    return FirebaseFirestore.instance
        .collection('hostels')
        .snapshots()
        .map((event) {
      List<Hostel> hostelsList = [];
      for (var element in event.docs) {
        Hostel hostel = Hostel.fromJson(element.data());
        FirebaseMessaging.instance.subscribeToTopic(hostel.hostelId);
        hostelsList.add(hostel);
      }
      return hostelsList;
    });
  }
}
